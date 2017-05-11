require 'will_paginate'
require 'will_paginate/active_record'
require 'pry'

class BikeShareApp < Sinatra::Base
  include WillPaginate::Sinatra::Helpers

  set :method_override, true

  get '/' do
     erb :dashboard
  end

  get '/stations' do
    erb :"stations/index"
  end

  get '/stations/new' do
    @cities = City.all
    erb :"stations/new"
  end

  post '/stations' do
    city = City.find_by name: params[:city][:name]
    station = city.stations.create(params[:station])
    redirect "/stations/#{station.id}"
  end

  get '/stations/view_all' do
    @stations = Station.all.paginate(:page => params[:page], :per_page => 30)
    erb :"stations/view_all"
  end

  get '/stations/:id' do
    @start_date = StartDate.all
    @start_station = StartStation.all
    @end_station = EndStation.all
    @station = Station.find(params[:id])
    @station_data = Station.data_analysis(@station.id)
    erb :"stations/show"
  end

  get '/stations/:id/edit' do
    @station = Station.find(params[:id])
    @cities = City.all
    erb :"stations/edit"
  end

  put '/stations/:id' do |id|
    @station = Station.find(params[:id])
    @station.update(params[:station])
    @station.update_city_id(params[:city][:name], @station)
    # city = City.find_by name: params[:city]["name"]
    # Station.find(params:id]).update(city_id: city.id)
    redirect "stations/#{@station.id}"
  end

  delete '/stations/:id' do |id|
    Station.destroy(id.to_i)
    redirect "/stations/view_all"
  end

  get '/station-dashboard' do
    @stations = Station.all
    @station_dashboard = Station.dashboard_analysis
    erb :"station-dashboard"
  end

  get '/trips' do
    erb :"trips/index"
  end

  get '/trips/view_all' do
    @trips = Trip.all.paginate(:page => params[:page], :per_page => 30)
    erb :"trips/view_all"
  end

  get '/trips/new' do
    @start_stations = StartStation.all
    @end_stations = EndStation.all
    @subscription_types = SubscriptionType.all
    erb :"trips/new"
  end

  get '/trips/:id/edit' do
    @stations = Station.all
    @subscription_types = SubscriptionType.all
    @start_stations = StartStation.all
    @end_stations = EndStation.all
    @trip = Trip.find(params[:id])
    erb :"/trips/edit"
  end

  get '/trips/:id' do
    @trip = Trip.find(params[:id])

    erb :"trips/show"
  end

  put '/trips/:id' do |id|
    @trip = Trip.find(params[:id])
    trip_details = params[:trip]
    ride_start_date = RideDate.find_or_create_by(RideDate.format_date_hash(trip_details["start_date_id"]))
    ride_end_date = RideDate.find_or_create_by(RideDate.format_date_hash(trip_details["end_date_id"]))
    trip_details["start_date_id"] = ride_start_date.id
    trip_details["end_date_id"] = ride_end_date.id
    @trip.update(trip_details)

    redirect "trips/#{@trip.id}"
  end

  post '/trips' do
    subscription_type = SubscriptionType.find_by(name: params[:subscription_type][:name])
    trip_details = params[:trip]
    ride_start_date = RideDate.find_or_create_by(RideDate.format_date_hash(trip_details["start_date_id"]))
    ride_end_date = RideDate.find_or_create_by(RideDate.format_date_hash(trip_details["end_date_id"]))
    trip_details["start_date"] = (StartDate.find_or_create_by(ride_date_id: ride_start_date.id)).id
    trip_details["end_date"] = (EndDate.find_or_create_by(ride_date_id: ride_end_date.id)).id
    trip_details["start_date_id"] = trip_details.delete("start_date")
    trip_details["end_date_id"] = trip_details.delete("end_date")
    @trip = subscription_type.trips.create(trip_details)
    redirect "/trips/#{@trip.id}"
  end

  delete '/trips/:id' do |id|
    Trip.destroy(id.to_i)
    redirect "/trips/view_all"
  end

  get '/trips-dashboard' do
    @dashboard_duration = Trip.dashboard_duration
    @dashboard_station = Trip.dashboard_station
    @dashboard_subscriptions = Trip.dashboard_subscriptions
    @dashboard_dates = Trip.dashboard_dates
    @dashboard_bikes = Trip.dashboard_bikes
    erb :"trips-dashboard"
  end

  get '/conditions' do
    erb :"conditions/index"
  end

  get '/conditions/new' do
    erb :"conditions/new"
  end

  post '/conditions' do
    @conditions = params[:condition]
    @conditions[:ride_date_id] = RideDate.find_or_create_by(RideDate.format_date_hash(@conditions[:ride_date_id])).id
    @ride_date = RideDate.find_or_create_by(params[:date])
    @condition = Condition.create(params[:condition])
    redirect "/conditions/#{@condition.id}"
  end

  get '/conditions/view_all' do
    @conditions = Condition.all.paginate(:page => params[:page], :per_page => 30)
    erb :"conditions/view_all"
  end

  get '/conditions/:id' do
    @condition = Condition.find(params[:id])

    erb :"conditions/show"
  end

  get '/conditions/:id/edit' do
    @condition = Condition.find(params[:id])
    @ride_date = RideDate.find(@condition.ride_date.id)
    erb :"conditions/edit"
  end

  put '/conditions/:id' do |id|
    @condition = Condition.find(params[:id])
    @condition.update(params[:condition])
    redirect "conditions/#{params[:id]}"
  end

  delete '/conditions/:id' do |id|
    Condition.destroy(id.to_i)
    redirect "/conditions/view_all"
  end

  get '/condition-dashboard' do
    erb :"condition-dashboard"
  end

end
