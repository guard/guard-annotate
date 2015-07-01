require 'bundler/gem_tasks'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new( :spec ) do |t|
  t.verbose = false
end

task :default => :spec

namespace( :spec ) do
  desc "Run all specs on multiple ruby versions (requires rvm)"
  task( :portability ) do
    %w{1.8.7 1.9.2 1.9.3}.each do |version|
      system <<-BASH
        bash -c 'source ~/.rvm/scripts/rvm;
                rvm #{version};
                echo "--------- version #{version} ---------\n";
                bundle install;
                rake spec'
      BASH
    end
  end
end
