require './spec/spec_helper'

RSpec.describe Station do
  describe "attributes" do
    it "returns value in name column" do
      city = City.create(name: "San Jose")
      station = Station.create(name: "MLK Station", dock_count: 19, city_id: 1, installation_date: "2013-5-11")

      expect(station.name).to eq("MLK Station")
      expect(station.dock_count).to eq(19)
      expect(station.city_id).to eq(1)
      expect(station.installation_date.class).to eq(Date)
    end
  end

  describe "validations" do
    it "is invalid without a name" do
      city = City.create(name: "San Jose")
      station_1 = Station.create(dock_count: 19, city_id: 1, installation_date: "2013-5-11")

      expect(station_1).to_not be_valid
    end

    it "is invalid without a dock count" do
      city = City.create(name: "San Jose")
      station_1 = Station.create(name: "MLK Station",city_id: 1, installation_date: "2013-5-11")

      expect(station_1).to_not be_valid
    end

    it "is invalid without a city_id" do
      city = City.create(name: "San Jose")
      station_1 = Station.create(name: "MLK Station", dock_count: 19, installation_date: "2013-5-11")

      expect(station_1).to_not be_valid
    end

    it "is invalid without an installation_date" do
      city = City.create(name: "San Jose")
      station_1 = Station.create(name: "MLK Station", city_id: 1, dock_count: 19)

      expect(station_1).to_not be_valid
    end
  end

  describe "data processing methods" do
    it "updates station city_id" do
      city_1 = City.create(name: "Denver")
      city_2 = City.create(name: "Paris")
      station = city_1.stations.create(name: "MLK Station", city_id: 1, dock_count: 19, installation_date: "2013-5-11")

      station.update_city_id("Paris", station)
      expect(station.city_id).to eq(2)
    end
  end

end
