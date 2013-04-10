module PgCharmer
  class ConnectionHandler
    def initialize
      # These caches are keyed by klass.name, NOT klass. Keying them by klass
      # alone would lead to memory leaks in development mode as all previous
      # instances of the class would stay in memory.
      @owner_to_pool = ThreadSafe::Cache.new(:initial_capacity => 2) do |h,k|
        h[k] = ThreadSafe::Cache.new(:initial_capacity => 2)
      end
      @class_to_pool = ThreadSafe::Cache.new(:initial_capacity => 2) do |h,k|
        h[k] = ThreadSafe::Cache.new
      end
    end

    def connection_pool_list
      owner_to_pool.values.compact
    end

    def establish_connection(owner, spec)
      puts "#{owner}: #{spec}"
      @class_to_pool.clear
      raise RuntimeError, "Anonymous class is not allowed." unless owner.name
      owner_to_pool[owner.name] = ActiveRecord::ConnectionAdapters::ConnectionPool.new(spec)
    end

    # Returns true if there are any active connections among the connection
    # pools that the ConnectionHandler is managing.
    def active_connections?
      connection_pool_list.any?(&:active_connection?)
    end

    # Returns any connections in use by the current thread back to the pool,
    # and also returns connections to the pool cached by threads that are no
    # longer alive.
    def clear_active_connections!
      connection_pool_list.each(&:release_connection)
    end

    # Clears the cache which maps classes.
    def clear_reloadable_connections!
      connection_pool_list.each(&:clear_reloadable_connections!)
    end

    def clear_all_connections!
      connection_pool_list.each(&:disconnect!)
    end

    # Locate the connection of the nearest super class. This can be an
    # active or defined connection: if it is the latter, it will be
    # opened and set as the active connection for the class it was defined
    # for (not necessarily the current class).
    def retrieve_connection(klass) #:nodoc:
      puts "retrieve_connection for #{klass}"
      pool = retrieve_connection_pool(klass)
      (pool && pool.connection) or raise ConnectionNotEstablished
    end

    # Returns true if a connection that's accessible to this class has
    # already been opened.
    def connected?(klass)
      conn = retrieve_connection_pool(klass)
      conn && conn.connected?
    end

    # Remove the connection for this class. This will close the active
    # connection and the defined connection (if they exist). The result
    # can be used as an argument for establish_connection, for easily
    # re-establishing the connection.
    def remove_connection(owner)
      if pool = owner_to_pool.delete(owner.name)
        @class_to_pool.clear
        pool.automatic_reconnect = false
        pool.disconnect!
        pool.spec.config
      end
    end

    # Retrieving the connection pool happens a lot so we cache it in @class_to_pool.
    # This makes retrieving the connection pool O(1) once the process is warm.
    # When a connection is established or removed, we invalidate the cache.
    #
    # Ideally we would use #fetch here, as class_to_pool[klass] may sometimes be nil.
    # However, benchmarking (https://gist.github.com/jonleighton/3552829) showed that
    # #fetch is significantly slower than #[]. So in the nil case, no caching will
    # take place, but that's ok since the nil case is not the common one that we wish
    # to optimise for.
    def retrieve_connection_pool(klass)
      class_to_pool[klass.name] ||= begin
        until pool = pool_for(klass)
          klass = klass.superclass
          break unless klass <= ActiveRecord::Base
        end

        class_to_pool[klass.name] = pool
      end
    end

    private

    def owner_to_pool
      @owner_to_pool[Process.pid]
    end

    def class_to_pool
      @class_to_pool[Process.pid]
    end

    def pool_for(owner)
      owner_to_pool.fetch(owner.name) {
        if ancestor_pool = pool_from_any_process_for(owner)
          # A connection was established in an ancestor process that must have
          # subsequently forked. We can't reuse the connection, but we can copy
          # the specification and establish a new connection with it.
          establish_connection owner, ancestor_pool.spec
        else
          owner_to_pool[owner.name] = nil
        end
      }
    end

    def pool_from_any_process_for(owner)
      owner_to_pool = @owner_to_pool.values.find { |v| v[owner.name] }
      owner_to_pool && owner_to_pool[owner.name]
    end
  end
end
