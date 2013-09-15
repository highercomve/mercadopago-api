require 'bundler/gem_tasks'
require 'rake'
require File.expand_path('../lib/mercadopago/version', __FILE__)

desc 'Run Tests'
task :test do
  sh "rspec"
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
  sh "git tag v#{Mercadopago::VERSION}"
  sh "git push github master"
  sh "git push github v#{Mercadopago::VERSION}"
  sh "gem push mercadopago-api-#{Mercadopago::VERSION}.gem"
end

