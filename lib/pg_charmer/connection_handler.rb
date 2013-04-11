require 'atomic'
require 'thread_safe'

module PgCharmer
  class ConnectionHandler
    def initialize
      @process_pid = Atomic.new(nil)
    end

    # This differs from the current public API.
    # https://github.com/rails/rails/commit/c3ca7ac09e960fa1287adc730e8ddc713e844c37
    def connection_pools
      self.ensure_ready
      @pools.values
    end

    # Returns true if there are any active connections among the connection
    # pools that the ConnectionHandler is managing.
    def active_connections?
      self.ensure_ready
      self.connection_pools.any?(&:active_connection?)
    end

    # Returns any connections in use by the current thread back to the pool,
    # and also returns connections to the pool cached by threads that are no
    # longer alive.
    def clear_active_connections!
      self.ensure_ready
      self.connection_pools.each(&:release_connection)
    end

    # Clears the cache which maps classes.
    def clear_reloadable_connections!
      self.ensure_ready
      self.connection_pools.each(&:clear_reloadable_connections!)
    end

    def clear_all_connections!
      self.ensure_ready
      self.connection_pools.each(&:disconnect!)
    end

    # Locate the connection of the nearest super class. This can be an
    # active or defined connection: if it is the latter, it will be
    # opened and set as the active connection for the class it was defined
    # for (not necessarily the current class).
    def retrieve_connection(klass) #:nodoc:
      self.ensure_ready
      pool = self.retrieve_connection_pool(klass)
      (pool && pool.connection) or raise ActiveRecord::ConnectionNotEstablished
    end

    # Returns true if a connection that's accessible to this class has
    # already been opened.
    def connected?(klass)
      return false if Process.pid != @process_pid.get
      conn = self.retrieve_connection_pool(klass)
      conn && conn.connected?
    end

    # Only called in ActiveRecord test code, so performance isn't an issue.
    def remove_connection(owner)
      self.clear_cache
      # Don't return a ConnectionSpecification hash since we've disabled establish_connection anyway
      return nil
    end

    # Called by ActiveRecord::ConnectionHandling#connection_pool.
    def retrieve_connection_pool(klass)
      self.ensure_ready
      self.pool_for(klass)
    end

    protected

    def prepare
      @process_pid.set(Process.pid)
      @pools = ThreadSafe::Cache.new(initial_capacity: 2)
    end

    def ensure_ready
      if Process.pid != @process_pid.get
        # We've been forked -> throw away connection pools
        prepare
      end
    end

    # Throw away all pools on next request
    def clear_cache
      @process_pid.set(nil)
    end

    def connection_for(klass)
      PgCharmer.force_connection || PgCharmer.connection_stack.last || PgCharmer.overwritten_default_connections[klass.name] || klass.default_connection || PgCharmer.default_connection
    end

    def pool_for(klass)
      # Sauspiel's reportable dependency makes Rails 3.2 request a connection early,
      # before the App is initialized. Return nil in that case, Rails deals with that
      return nil if ActiveRecord::Base.configurations[Rails.env].nil?

      connection = connection_for(klass)
      # Ideally we would use #fetch here, as class_to_pool[klass] may sometimes be nil.
      # However, benchmarking (https://gist.github.com/jonleighton/3552829) showed that
      # #fetch is significantly slower than #[]. So in the nil case, no caching will
      # take place, but that's ok since the nil case is not the common one that we wish
      # to optimise for.
      @pools[connection] ||= begin
        resolver = PgCharmer::ConnectionSpecificationResolver.new connection, ActiveRecord::Base.configurations[Rails.env]
        spec = resolver.spec

        unless ActiveRecord::Base.respond_to?(spec.adapter_method)
          raise ActiveRecord::AdapterNotFound, "database configuration specifies nonexistent #{spec.config[:adapter]} adapter"
        end

        ActiveRecord::ConnectionAdapters::ConnectionPool.new(spec)
      end
    end
  end
end
