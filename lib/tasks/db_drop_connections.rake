namespace :db do
  namespace :drop do
    task connections: :environment do
      # load rails configuration
      config   = Rails.configuration.database_configuration[Rails.env]

      # ignore if it's not postresql
      exit unless config['adapter'] == 'postgresql'

      # build db dictionary
      dbconn = { :host => config['host'], :dbname => 'postgres', user: config['username'], password: config['password'] }
      dbconn[:sslmode] = config['sslmode'] if config.has_key? 'sslmode'

      # connect to postresql
      conn = PG.connect(dbconn)

      q = 'SELECT pg_terminate_backend(pg_stat_activity.pid) ' +
        'FROM pg_stat_activity ' +
        "WHERE pg_stat_activity.datname = '#{config['database']}' " +
        'AND pid <> pg_backend_pid(); '

      conn.exec(q)

    end
  end
end
