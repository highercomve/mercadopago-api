# require 'bundler/gem_tasks'
require 'rake'
require File.expand_path('../lib/mercadopago/version', __FILE__)

desc 'Run Tests'
task :test do
	sh "rspec"
end

desc 'Builds the gem'
task :build do
	  sh "gem build mercadopago-api.gemspec"
end

desc 'Builds and installs the gem'
task :install => :build do
	  sh "gem install mercadopago-api-#{Mercadopago::VERSION}"
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
	sh "git tag v#{Mercadopago::VERSION}"
	sh "git push origin develop"
	sh "git push origin v#{Mercadopago::VERSION}"
	sh "gem push mercadopago-api-#{Mercadopago::VERSION}.gem"
end

