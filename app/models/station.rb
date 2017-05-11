class Station < ActiveRecord::Base
  belongs_to :city
  has_one :start_station
  has_one :end_station

  validates :name, presence: true
  validates :city_id, presence: true
  validates :dock_count, presence: true
  validates :installation_date, presence: true

  def update_city_id(city_name, station)
    city = City.find_by name: city_name
    station.update city_id: city.id
  end

  def self.data_analysis(station_id)
    {rides_started_at_station: Station.rides_started_at_station(station_id),
    rides_ended_at_station: Station.rides_ended_at_station(station_id),
    most_frequent_destination_station: Station.most_frequent_destination_station(station_id),
    most_frequent_origination_station: Station.most_frequent_origination_station(station_id),
    date_with_most_trips: Station.date_with_most_trips(station_id),
    most_frequent_zip_at_station: Station.most_frequent_zip_at_station(station_id),
    most_frequent_bike_id_at_station: Station.most_frequent_bike_id_at_station(station_id)
    }
  end

  def self.rides_started_at_station(station_id)
    if Station.find(station_id).start_station.nil?
      rides = 0
    else
      rides = Station.find(station_id).start_station.trips.count
    end
  end

  def self.rides_ended_at_station(station_id)
    if Station.find(station_id).end_station.nil?
      rides = 0
    else
      rides = Station.find(station_id).end_station.trips.count
    end
  end

  def self.most_frequent_destination_station(station_id)
    if Station.find(station_id).end_station.nil?
      "No rides have begun at this station"
    else
      end_station_id = Station.find(station_id).start_station.trips.group(:end_station_id).order('count_id asc').count('id').keys.last
      EndStation.find(end_station_id).station.name
    end
  end

  def self.most_frequent_origination_station(station_id)
    if Station.find(station_id).start_station.nil?
      "No rides have ended at this station"
    else
      start_station_id = Station.find(station_id).end_station.trips.group(:start_station_id).order('count_id asc').count('id').keys.last
    end
    StartStation.find(start_station_id).station.name
  end

  def self.date_with_most_trips(station_id)
    if Station.find(station_id).start_station.nil?
      "No rides have started at this station"
    else
      trips = Station.find(station_id).start_station.trips
      start_date_id = trips.group(:start_date_id).order("count_id asc").count('id').keys.last
      start_date = StartDate.find(start_date_id)
      "#{start_date.ride_date.month}-#{start_date.ride_date.day}-#{start_date.ride_date.year}"
      end
    end

  def self.most_frequent_zip_at_station(station_id)
    if Station.find(station_id).start_station.nil?
     "No rides have started at this station"
    else
      trips = Station.find(station_id).start_station.trips
      zip = trips.group(:zip_code).order("count_id asc").count('id').keys.last
      if zip.nil?
        zip = trips.group(:zip_code).order("count_id asc").count('id').keys[-2]
      end
     zip
    end
  end
  def self.most_frequent_bike_id_at_station(station_id)
    if Station.find(station_id).start_station.nil?
      "No rides have started at this station"
    else
      trips = Station.find(station_id).start_station.trips
      trips.group(:bike_id).order("count_id asc").count('id').keys.last
    end
  end

  def self.dashboard_analysis
    {count: Station.all.count,
    average_available_bikes_per_station: Station.average(:dock_count).round,
    most_bikes_available_at_a_station: Station.maximum(:dock_count),
    station_where_most_bikes_available: Station.station_where_most_bikes_available,
    fewest_bikes_available_at_station: Station.minimum(:dock_count),
    station_where_fewest_bikes_available: Station.station_where_fewest_bikes_available,
    newest_station: Station.order("installation_date DESC").first.name,
    oldest_station: Station.order("installation_date DESC").last.name
    }
  end

  def self.station_where_most_bikes_available
    Station.where(dock_count: Station.maximum(:dock_count)).map do |station|
      station.name
    end
  end

  def self.station_where_fewest_bikes_available
    Station.where(dock_count: Station.minimum(:dock_count)).map do |station|
      station.name
    end
  end

end
