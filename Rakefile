require "bundler/gem_tasks"

require "rspec"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("test:spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

namespace :test do
  desc "Run integration test"
  task :integration do
    puts
    puts "Start integration test"
    cap = `cap -T`
    tasks = %w{db:console db:dump db:down}
    tasks.each do |task|
      unless `cap -T` =~ /cap\ ssh/
        puts "Integration test fails!"
        exit!
      end
    end
    puts "Integration test successfully!"
  end
end
