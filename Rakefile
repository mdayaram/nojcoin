# Rakefile

require 'sinatra/activerecord/rake'
require_relative './app'

namespace :db do
  desc 'Load the seed data from db/seeds.rb'
  task :seed do
    require_relative './db/seeds'
  end
end
