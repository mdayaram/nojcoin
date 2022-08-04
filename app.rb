#!/usr/bin/env ruby

require 'enumerator'
require_relative './config/environment'
require_relative './models/trade'

before do
  @trade = Trade.order("created_at DESC").first
end

get '/styles/:file.css' do
  scss params[:file].to_sym
end

get '/' do
  haml :index
end

get '/about' do
  haml :about
end

get '/who' do
  @who = params[:is]
  haml :who
end

get '/sad' do
  @sad = params[:person]
  haml :sad
end

get '/stolen/:id' do
  @mytrade = Trade.find(params[:id])
  haml :stolen
end

get '/mine' do
  @trade.offer ||= 0
  @trade.offer = @trade.offer.to_f + Random.rand

  # According to google, 85 trillion is the world GDP, so nojcoin cannot be
  # worth more than that.
  @trade.offer = 85000000000000.00 if @trade.offer.to_f > 85000000000000.00
  @trade.offer = 0 if @trade.offer.to_f < 0

  @trade.save!
  haml :mine
end

get '/market' do
  haml :market
end

get '/steal' do
  haml :steal
end

post '/steal' do
  stealer = twotter? params[:stealer]
  if stealer.nil?
    redirect "/who?is=#{params[:stealer]}"
  end

  if stealer == @trade.to
    redirect "/sad?person=#{stealer}"
  end

  break_factor = ((Time.now - @trade.created_at) / 60 ) + 1
  break_factor = Random.rand(@trade.offer.to_f.abs + 1) if break_factor > @trade.offer.to_f
  newtrade = Trade.new
  newtrade.to = stealer
  newtrade.from = @trade.to
  newtrade.offer = @trade.offer.to_f -  break_factor * Random.rand
  newtrade.offer = 0 if newtrade.offer.to_f < 0
  newtrade.notes = "burn!"

  if newtrade.save
    redirect "/stolen/#{newtrade.id}"
  else
    haml :steal
  end
end

get '/mock/:id' do
  @trade = Trade.find(params[:id])
  haml :mock
end

post '/mock' do
  trade = Trade.find(params[:id])
  message_header = "Hey, #{trade.from}! "
  if params[:msg].nil? || params[:msg].empty?
    message_body = "Neener-neener-neener!"
  else
    message_body = params[:msg][0..(139 - message_header.length)]
  end

  integrity_factor = 10 # magic numbers!
  trade.offer = trade.offer.to_f -  integrity_factor * Random.rand
  trade.offer = 0 if trade.offer.to_f < 0
  trade.notes = message_body

  trade.save!
  tweet "#{message_header}#{message_body}"
  redirect "/mocked/#{params[:id]}"
end

get '/mocked/:id' do
  haml :mocked
end

get '/ledger' do
  @trades = Trade.order("created_at DESC")
  haml :ledger, :locals => { :feed_display => "none" }
end

get '/port' do
  return "#{ENV["PORT"]}"
end

# I am ashamed of this, actually, pretty much all of this.
get '/market-chart.js' do
  headers('Content-Type' => "application/javascript")
  trades = Trade.order(created_at: :desc).limit(12)
  points = []
  trades.each do |t|
    points << t.offer.to_f
  end
  # Only display the last 12 trade points.
  points.reverse!

  data = "var data = {\n"
  data += "labels: " + (1..points.length).to_a.to_s + ",\n"
  data += "datasets: [{\n"
  data += "label: \"Nojcoin Dollar Value\",\n"
  data += "fillColor: \"rgba(151,187,205,0.2)\",\n"
  data += "strokeColor: \"rgba(151,187,205,1)\",\n"
  data += "pointColor: \"rgba(151,187,205,1)\",\n"
  data += "pointStrokeColor: \"#fff\",\n"
  data += "pointHighlightFill: \"#fff\",\n"
  data += "pointHighlightStroke: \"rgba(151,187,205,1)\",\n"
  data += "data: #{points.to_s}\n"
  data += "}]};\n\n"
  data += "var options = { };\n"
  data += "var ctx = document.getElementById(\"marketChart\").getContext(\"2d\");\n"
  data += "var mychart = new Chart(ctx).Line(data, options);\n"
  return data
end
