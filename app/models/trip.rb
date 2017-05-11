class Trip < ActiveRecord::Base
  belongs_to :start_station
  belongs_to :end_station
  belongs_to :subscription_type
  belongs_to :start_date, :class_name => 'RideDate', :foreign_key => 'start_date_id'
  belongs_to :end_date, :class_name => 'RideDate', :foreign_key => 'end_date_id'

  validates :duration, presence: true
  validates :start_date_id, presence: true
  validates :start_station_id, presence: true
  validates :end_date_id, presence: true
  validates :end_station_id, presence: true
  validates :bike_id, presence: true
  validates :subscription_type_id, presence: true

  def self.subscription_type_percentage(subscription_id)
    total_subscribers = Trip.where(subscription_type_id: subscription_id).count
    percentage = (total_subscribers / Trip.all.count.to_f) * 100
    percentage.to_i.to_s + "%"
  end

  def self.dashboard_duration
    {
      average_duration: Trip.average(:duration).round,
      longest_ride_id: Trip.order("duration DESC").first.id,
      shortest_ride_id: Trip.order("duration DESC").last.id
    }
  end
  
  def self.dashboard_station
    {
      most_common_starting_station: Trip.most_common_starting_station,
      most_common_ending_station: Trip.most_common_ending_station
    }
  end

  def self.dashboard_bikes
    {
      most_ridden_bike_id: Trip.most_ridden_bike_id,
      most_ridden_bike_trips: Trip.most_ridden_bike_trips,
      least_ridden_bike_id: Trip.least_ridden_bike_id,
      least_ridden_bike_trips: Trip.least_ridden_bike_trips
    }
  end

  def self.dashboard_subscriptions
    {
      subscription_customers_name: Trip.subscription_customers_name,
      subscription_subscribers_name: Trip.subscription_subscribers_name,
      subscription_customers_count: Trip.subscription_customers_count,
      subscription_subscribers_count: Trip.subscription_subscribers_count,
      subscription_subscribers_percentage: Trip.subscription_subscribers_percentage,
      subscription_customers_percentage: Trip.subscription_customers_percentage
    }
  end

  def self.dashboard_dates
    {
      date_with_highest_trips_date: Trip.date_with_highest_trips_date,
      date_with_highest_trips_count: Trip.date_with_highest_trips_count,
      date_with_lowest_trips_date: Trip.date_with_lowest_trips_date,
      date_with_lowest_trips_count: Trip.date_with_lowest_trips_count
    }
  end

  def self.most_common_starting_station
    StartStation.find(Trip.group(:start_station_id).order('count_id asc').count('id').keys.last).station.name
  end

  def self.most_common_ending_station
    EndStation.find(Trip.group(:start_station_id).order('count_id asc').count('id').keys.first).station.name
  end

  def self.most_ridden_bike_id
    Trip.group(:bike_id).order('count_id asc').count("id").keys.last
  end

  def self.most_ridden_bike_trips
    Trip.group(:bike_id).order('count_id asc').count("id").values.last
  end

  def self.least_ridden_bike_id
    all_bikes = Trip.pluck(:bike_id)
    bike_ids = all_bikes.group_by { |id| all_bikes.count(id) }.min.last.uniq
    bike_ids
  end

  def self.least_ridden_bike_trips
    Trip.group(:bike_id).order('count_id asc').count("id").values.first
  end

  def self.subscription_customers_name
    subscription_type = SubscriptionType.find(1)
    subscription_type.name
  end

  def self.subscription_subscribers_name
    subscription_type = SubscriptionType.find(2)
    subscription_type.name
  end

  def self.subscription_customers_count
    subscription_type = SubscriptionType.find(1)
    subscription_type.name
    Trip.where(subscription_type_id: subscription_type.id).count
  end

  def self.subscription_subscribers_count
    subscription_type = SubscriptionType.find(2)
    subscription_type.name
    Trip.where(subscription_type_id: subscription_type.id).count
  end

  def self.subscription_subscribers_percentage
    subscription_type = SubscriptionType.find(2)
    Trip.subscription_type_percentage(subscription_type.id)
  end

  def self.subscription_customers_percentage
    subscription_type = SubscriptionType.find(1)
    Trip.subscription_type_percentage(subscription_type.id)
  end

  def self.date_with_highest_trips_count
    Trip.group(:start_date_id).order('count_id asc').count("id").values.last
  end

  def self.date_with_highest_trips_date
    date_id = Trip.group(:start_date_id).order('count_id asc').count("id").keys.last
    "#{StartDate.find(date_id).ride_date.month}/#{StartDate.find(date_id).ride_date.day}/#{StartDate.find(date_id).ride_date.year}"
  end

  def self.date_with_lowest_trips_count
    Trip.group(:start_date_id).order('count_id asc').count("id").values.first
  end

  def self.date_with_lowest_trips_date
    date_id = Trip.group(:start_date_id).order('count_id asc').count("id").keys.first
    "#{StartDate.find(date_id).ride_date.month}/#{StartDate.find(date_id).ride_date.day}/#{StartDate.find(date_id).ride_date.year}"
  end

  def self.get_months_and_years
    months_and_years = {}
    years = RideDate.distinct.pluck(:year)
    years.map do |year|
      months_and_years[year] = RideDate.where(year: year).distinct.pluck(:month)
    end
    months_and_years
  end

  def self.year_month_pairs
    year_month = []
    Trip.get_months_and_years.each do |year, months|
      year_month << months.map do |month|
        [year, month]
      end
    end
    year_month
  end

  def self.get_all_ride_dates
    days = {}
    Trip.year_month_pairs.each do |year_of_months|
      year_of_months.map do |month|
        days[month] = RideDate.where(year: month.first, month: month.last)
      end
    end
    days
  end

  def self.get_monthly_totals
    monthly_totals = {}
    Trip.get_all_ride_dates.each do |month, all_the_days|
      monthly_totals[month] = all_the_days.map do |individual_day|
        individual_day.trips.count
      end
    end
    monthly_totals
  end

  def self.monthly_breakdown
    monthly_totals = Trip.get_monthly_totals
    month_by_month = {}
    monthly_totals.each do |month, daily_totals|
      month_by_month[month] = daily_totals.inject(0){|sum,x| sum + x }
    end
    month_by_month
  end
end
