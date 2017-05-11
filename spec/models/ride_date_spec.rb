require_relative '../spec_helper'

RSpec.describe RideDate do
  describe "attributes" do
    it "returns values in columns" do
      ride_date = RideDate.create(day: 12, month: 2, year: 2012)

      expect(ride_date.day).to eq(12)
      expect(ride_date.month).to eq(2)
      expect(ride_date.year).to eq(2012)
    end
  end

  describe "validations" do
    it "is invalid without a day" do
      ride_date = RideDate.create(month: 2, year: 2012)

      expect(ride_date).to be_invalid
    end

    it "is invalid without a month" do
      ride_date = RideDate.create(day: 12, year: 2012)

      expect(ride_date).to be_invalid
    end

    it "is invalid without a year" do
      ride_date = RideDate.create(day: 12, month: 2)

      expect(ride_date).to be_invalid
    end
  end

  describe "access to trips" do
    it "can access trip duration" do
      city = City.create(name: "San Jose")
      city.stations.create(name: "MLK Station", dock_count: 19, city_id: 1, installation_date: "2013-5-11")
      city.stations.create(name: "Cesar Chavez Station", dock_count: 5, city_id: 1, installation_date: "2013-5-19")
      start_station = StartStation.create(station_id: 2)
      end_station = EndStation.create(station_id: 1)
      subscription_type = SubscriptionType.create(name: "Customer")
      ride_date = RideDate.find_or_create_by(day: 12, month: 8, year: 2012)
      StartDate.create(ride_date_id: 1)
      EndDate.create(ride_date_id: 1)
      trip = subscription_type.trips.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 1,
                                start_date_id: 1,
                                end_date_id: 1,
                                bike_id: 122,
                                zip_code: 80218)
      expect(ride_date.start_date.trips.find(1).duration).to eq(400)
    end
  end

  describe "access to conditions" do
    it "can access mean wind speed" do
      ride_date = RideDate.find_or_create_by(day: 12, month: 8, year: 2012)
      Condition.create(ride_date_id:      1,
                       max_temperature:   95,
                       mean_temperature:  80,
                       min_temperature:   60,
                       mean_humidity:     70,
                       mean_visibility:   12,
                       mean_wind_speed:   11,
                       precipitation:     "0.4")

      expect(ride_date.condition.mean_wind_speed).to eq(11)
    end
  end
end
