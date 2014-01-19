require 'active_record'

configure :development do
  set :database, 'sqlite:///db/dev.sqlite3'
  set :show_exceptions, true
end

configure :production do
  $stderr.puts "DATABASE URL: " + ENV['DATABASE_URL']
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
