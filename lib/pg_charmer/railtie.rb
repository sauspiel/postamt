module PgCharmer
  class Railtie < Rails::Railtie
    railtie_name 'pg_charmer'

    initializer "pg_charmer.hook_active_record", after: 'active_record.initialize_database' do |app|
      PgCharmer.hook_active_record!
    end
  end
end
