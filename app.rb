#!/usr/bin/env ruby

require 'enumerator'
require_relative './config/environment'
require_relative './models/trade'

get '/styles/:file.css' do
  scss params[:file].to_sym
end

get '/' do
  trade = Trade.order("created_at DESC").first
  @owner = trade.to
  @value = trade.offer
  @notes = trade.notes
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
  @trade = Trade.find(params[:id])
  haml :stolen
end

get '/mine' do
  @trade = Trade.order("created_at DESC").first
  @trade.offer ||= 0
  @trade.offer = @trade.offer.to_i + 1
  @trade.save!
  haml :mine
end

get '/market' do
  haml :market
end

get '/steal' do
  trade = Trade.order("created_at DESC").first
  @owner = trade.to
  haml :steal
end

post '/steal' do
  stealer = twotter? params[:stealer]
  if stealer.nil?
    redirect "/who?is=#{params[:stealer]}"
  end

  last = Trade.order("created_at DESC").first

  if stealer == last.to
    redirect "/sad?person=#{stealer}"
  end

  @trade = Trade.new
  @trade.to = stealer
  @trade.from = last.to
  @trade.offer = last.offer
  @trade.notes = "burn!"

  if @trade.save
    tweet "Oh no! #{@trade.to} just stole me from #{@trade.from}!"
    redirect "/stolen/#{@trade.id}"
  else
    haml :steal
  end
end

get '/market-chart.js' do
  headers('Content-Type' => "application/javascript")
  trades = Trade.order("created_at ASC")
  values = []
  trades.each do |t|
    values << t.offer.to_i
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
