#!/usr/bin/env ruby

require 'enumerator'
require_relative './config/environment'
require_relative './models/trade'

get '/styles/:file.css' do
  scss params[:file].to_sym
end

get '/' do
  @trade = Trade.order("created_at DESC").first
  haml :index
end

get '/about' do
  @trade = Trade.order("created_at DESC").first
  haml :about
end

get '/who' do
  @trade = Trade.order("created_at DESC").first
  @who = params[:is]
  haml :who
end

get '/sad' do
  @trade = Trade.order("created_at DESC").first
  @sad = params[:person]
  haml :sad
end

get '/stolen/:id' do
  @trade = Trade.order("created_at DESC").first
  @mytrade = Trade.find(params[:id])
  haml :stolen
end

get '/mine' do
  @trade = Trade.order("created_at DESC").first
  @trade.offer ||= 0
  @trade.offer = @trade.offer.to_f + Random.rand
  # in case of overflow...
  @trade.offer = 0 if @trade.offer.to_f < 0
  @trade.save!
  haml :mine
end

get '/market' do
  @trade = Trade.order("created_at DESC").first
  haml :market
end

get '/steal' do
  @trade = Trade.order("created_at DESC").first
  haml :steal
end

post '/steal' do
  stealer = twotter? params[:stealer]
  if stealer.nil?
    redirect "/who?is=#{params[:stealer]}"
  end

  @trade = Trade.order("created_at DESC").first

  if stealer == @trade.to
    redirect "/sad?person=#{stealer}"
  end

  break_factor = ((Time.now - @trade.created_at) / 60 ) + 1
  break_factor = Random.rand(@trade.offer.to_f.abs + 1) if break_factor > @trade.offer.to_f
  newtrade = Trade.new
  newtrade.to = stealer
  newtrade.from = @trade.to
  newtrade.offer = @trade.offer.to_f -  break_factor * Random.rand
  newtrade.offer = 0 if newtrade.offer < 0
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
  @trade = Trade.order("created_at DESC").first
  haml :mocked
end

get '/ledger' do
  @trades = Trade.order("created_at DESC")
  @trade = @trades.first
  haml :ledger
end

# I am ashamed of this, actually, pretty much all of this.
get '/market-chart.js' do
  headers('Content-Type' => "application/javascript")
  trades = Trade.order("created_at ASC")
  values = []
  trades.each do |t|
    values << t.offer.to_f
  end
  # We only want to display a max of 12 data points (potentially 23, whatevs)
  points = []
  if values.length > 12
    chunksize = values.length/12
    values.each_slice(chunksize) do |v|
      points << v.inject{ |sum, el| sum + el }.to_f / v.size
    end
  else
    points = values
  end
  if points.last != values.last
    points << values.last
  end
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
