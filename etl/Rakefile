require_relative 'lib/common.rb'

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    db = Sequel.connect($config[:database_url])

    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, 'migrations/', target: args[:version].to_i)
    else
      puts 'Migrating to latest'
      Sequel::Migrator.run(db, 'migrations/')
    end
  end
end
