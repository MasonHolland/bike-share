require './spec/spec_helper'

RSpec.describe City do
  describe "attributes" do
    it "returns value in name column" do
      city = City.create(name: "San Jose")

      expect(city.name).to eq("San Jose")
    end
  end

  describe "validations" do
    it "is invalid without a name" do
      city = City.create(name: nil)

      expect(city).to be_invalid
    end
  end

  describe "access to stations" do
    it "can access station name" do
      City.create(name: "San Jose")
      city = City.find(1)
      city.stations.create(name: "MLK Station", dock_count: 19, city_id: 1, installation_date: "8/6/2013")


      expect(city.stations.first.name).to eq("MLK Station")
    end
  end



end
