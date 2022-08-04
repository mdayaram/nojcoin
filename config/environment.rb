require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'sinatra/base'
require 'active_record'
require 'sinatra/activerecord'
require 'sinatra/support/numeric'
require 'haml'
require 'sass'
require 'twitter'

configure do
  set :server, 'webrick' # needed because sinatra thinks the twitter gem is a server.
  set :app_file, File.expand_path(File.join(File.dirname(__FILE__), "..", "app.rb"))
  set :haml, { :format => :html5 }

  register Sinatra::Numeric
end

configure :development do
  set :database, { adapter: 'sqlite3', database: 'dev.sqlite3' }
  set :show_exceptions, true
  set :twitter, nil
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

  twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
    config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
    config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
    config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
  end
  set :twitter, twitter_client
end

helpers do
  def tweet(msg)
    settings.twitter.update(msg) if !settings.twitter.nil?
    puts "TWITTER MSG: #{msg}"
  end

  def twotter?(user)
    if !user.start_with? "@"
      user = "@" + user
    end

    return user if settings.twitter.nil?

    if settings.twitter.user?(user[1..-1])
      return user
    else
      return nil
    end
  end
end
