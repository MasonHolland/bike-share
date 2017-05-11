require './app/models/city.rb'
require './app/models/station.rb'
require './app/models/start_station.rb'
require './app/models/end_station.rb'
require './app/models/subscription_type.rb'
require './app/models/trip.rb'
require './app/models/ride_date.rb'
require './app/models/start_date.rb'
require './app/models/end_date.rb'
require './app/models/condition.rb'
require 'csv'

City.destroy_all
Station.destroy_all
StartStation.destroy_all
EndStation.destroy_all
SubscriptionType.destroy_all
Trip.destroy_all
StartDate.destroy_all
EndDate.destroy_all
RideDate.destroy_all
Condition.destroy_all

def format_date(unformatted_date)
  date_elements = unformatted_date.split("/")
  formatted_date = date_elements[2] + "-" + date_elements[0] + "-" + date_elements[1]
end

def format_date_hash(unformatted_date)
  date_elements = unformatted_date.split("/")
  formatted_date = {day: date_elements[1], month: date_elements[0], year: date_elements[2]}
end

def format_zip_code(zipcode)
  return nil if zipcode.nil?
  return nil if zipcode.to_s.length < 5
  zipcode.to_s[0..4].to_i
end

station_text = File.read('./db/csv/station.csv')
station = CSV.parse(station_text, :headers => true, header_converters: :symbol)
station.each do |row|
  city = City.find_or_create_by!(name: row[:city])
  station = city.stations.create!(name: row[:name],
                                  dock_count: row[:dock_count],
                                  installation_date: format_date(row[:installation_date]))
  StartStation.create(station_id: station.id)
  EndStation.create(station_id: station.id)
end

trip_text = File.read('./db/csv/trip.csv')
trip = CSV.parse(trip_text, :headers => true, header_converters: :symbol)
trip.each do |row|
  ride_date_start = RideDate.find_or_create_by!(format_date_hash(row[:start_date]))
  ride_date_end = RideDate.find_or_create_by!(format_date_hash(row[:end_date]))
  start_date = StartDate.find_or_create_by!(ride_date_id: ride_date_start.id)
  end_date = EndDate.find_or_create_by!(ride_date_id: ride_date_end.id)
  start_station = Station.find_by(name: row[:start_station_name])
  end_station = Station.find_by(name: row[:end_station_name])
  next if start_station.nil? || end_station.nil?
  subscription = SubscriptionType.find_or_create_by!(name: row[:subscription_type])
  subscription.trips.create!(duration: row[:duration],
                            start_station_id: Station.find_by(name: row[:start_station_name]).start_station.id,
                            end_station_id: Station.find_by(name: row[:end_station_name]).end_station.id,
                            start_date_id: start_date.id,
                            end_date_id: end_date.id,
                            bike_id: row[:bike_id],
                            zip_code: format_zip_code(row[:zip_code]))
end

condition_text = File.read('./db/csv/weather.csv')
condition = CSV.parse(condition_text, :headers => true, header_converters: :symbol)
condition.each do |row|
  ride_date_id = RideDate.find_or_create_by!(format_date_hash(row[:date])).id
  next if row[:max_temperature_f].nil?
  next if row[:mean_temperature_f].nil?
  next if row[:min_temperature_f].nil?
  next if row[:mean_humidity].nil?
  next if row[:mean_visibility_miles].nil?
  next if row[:mean_wind_speed_mph].nil?
  next if row[:precipitation_inches].nil?

  condition = Condition.create!(ride_date_id: ride_date_id,
                                  max_temperature: row[:max_temperature_f],
                                  mean_temperature: row[:mean_temperature_f],
                                  min_temperature: row[:min_temperature_f],
                                  mean_humidity: row[:mean_humidity],
                                  mean_visibility: row[:mean_visibility_miles],
                                  mean_wind_speed: row[:mean_wind_speed_mph],
                                  precipitation: row[:precipitation_inches])
end
