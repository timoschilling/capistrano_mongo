require "spec_helper"

describe CapistranoMongo::Recipes, "loaded into a configuration" do
  describe "db" do
    before do
      [:rails_env, :user, :current_path, :database].each do |key|
        configuration.set key, "#{key}"
      end
      configuration.set :port, 22
      configuration.role :db, "example.com"
    end

    let :configuration do
      configuration = Capistrano::Configuration.new
      described_class.load_into configuration
      configuration.extend Capistrano::Spec::ConfigurationExtension
    end

    describe "console" do
      it "defines db:console" do
        configuration.find_task("db:console").should_not be_nil
      end

      it "should run the remote command" do
        configuration.find_and_execute_task "db:console"
        configuration.should have_run_locally "ssh -l user example.com -p 22 -t 'cd current_path && mongo database'"
      end
    end
  end
end
