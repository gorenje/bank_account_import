# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "bank_account_import"
  gem.homepage = "https://github.com/gorenje"
  gem.license = "MIT"
  gem.summary = %Q{Support various CSV files}
  gem.description = %Q{Support Bank export files that are in CSV format.}
  gem.email = "gerrit.riessen@gmail.com"
  gem.authors = ["Gerrit Riessen"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Dir[File.join(File.dirname(__FILE__), 'lib', 'tasks','*.rake')].each do |f|
  load f
end

task :default => :test

desc "Start a pry shell and load all gems"
task :shell do
  require 'pry'
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  require_relative 'lib/bank_account_import.rb'
  Pry.editor = "emacs"
  Pry.start
end
