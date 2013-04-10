module PgCharmer
  class Railtie < Rails::Railtie
    railtie_name 'pg_charmer'

    initializer "pg_charmer.install", before: 'active_record.initialize_database' do |app|
      PgCharmer.install!
    end
  end
end
