require 'active_record'
require 'sinatra/activerecord'
require 'haml'
require 'sass'

configure do
  set :haml, { :format => :html5 }
end

configure :development do
  set :database, 'sqlite:///db/dev.sqlite3'
  set :show_exceptions, true
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
