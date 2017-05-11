require_relative '../spec_helper'

RSpec.describe EndDate do
  describe "attributes" do
    it "can access values in columns" do
      end_date = EndDate.create(ride_date_id: 1)

      expect(end_date.ride_date_id).to eq(1)
    end
  end

  describe "validations" do
    it "is invalid without a ride date id" do
      RideDate.create(day: 12, month: 9, year: 2012)
      end_date = EndDate.create(ride_date_id: nil)
      
      expect(end_date).to be_invalid
    end
  end

  describe "relationships" do
    it "can access ride date attributes" do
      RideDate.create(day: 12, month: 9, year: 2012)
      end_date = EndDate.create(ride_date_id: 1)

      expect(end_date.ride_date.month).to eq(9)
    end

    it "can access trip attributes" do
      RideDate.create(day: 12, month: 9, year: 2012)
      end_date = EndDate.create(ride_date_id: 1)
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 2,
                                start_date_id: 1,
                                end_date_id: 1,
                                bike_id: 122,
                                zip_code: 80218)

      expect(end_date.trips.count).to eq(1)
    end
  end
end
