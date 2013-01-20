require "capistrano/configuration"

module CapistranoMongo
  module Recipes
    def self.load_into(configuration)
      configuration.load do
        namespace :db do
          desc "Opens a remote mongo console"
          task :console, :roles => :db do
            abort "You must set a database" unless database
            hostname = find_servers_for_task(current_task).first

            run_locally "ssh -l #{user} #{hostname} -p #{port} -t 'cd #{current_path} && mongo #{database}'"
          end

          desc "Create a dump from the remote db"
          task :dump, :roles => :db do
            abort "You must set a database" unless database
            dump_name = ENV['DUMP_NAME'] ||= "#{database}_#{Time.now.strftime("%Y%m%d%H%M%S")}"
            dump_file = "#{dump_name}.tgz"

            on_rollback do
              run "rm -rf #{dump_file}; true"
            end

            run "mongodump -d #{database} -o #{dump_name} && tar czf #{dump_file} #{dump_name} && rm -rf #{dump_name};"

            get dump_file, dump_file
            run "rm -rf #{dump_file}"
            run_locally "tar xzf #{dump_file}"
            run_locally "rm -rf #{dump_name}.tgz"
          end

          desc "Sync DB from remote server to local machine"
          task :down, :roles => :db do
            abort "You must set a local database" unless local_database
            dump
            dump_name = ENV['DUMP_NAME']

            run_locally "mongorestore --drop -d #{local_database} #{dump_name}/#{database}/"
            run_locally "rm -rf #{dump_name}"
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  CapistranoMongo::Recipes.load_into(Capistrano::Configuration.instance)
end
