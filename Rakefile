# Rakefile

require_relative './app'
require 'sinatra/activerecord/rake'

namespace :db do
  desc 'Load the seed data from db/seeds.rb'
  task :seed do
    require_relative './db/seeds'
  end
end
