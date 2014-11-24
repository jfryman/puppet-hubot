require 'rake'
require 'rake/tasklib'
require 'rspec/core/rake_task'
require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

desc 'Run the tests'
RSpec::Core::RakeTask.new(:do_test) do |t|
  t.rspec_opts = ['--color', '-f d']
  t.pattern = 'spec/*/*_spec.rb'
end

Puppet::Util::Log.level = :warning
Puppet::Util::Log.newdestination(:console)

PuppetLint::RakeTask.new :lint do |config|
    config.pattern = 'spec/fixtures/modules/hubot/manifests/*.pp'
    config.disable_checks = ['80chars', 'class_inherits_from_params_class', 'autoloader_layout']
    config.relative = false
    config.with_context = true
    config.show_ignored = true
end

desc 'Run puppet-lint on the manifests'

task :default => [:spec_prep, :do_test, :lint, :spec_clean]
task :test => [:default]
