require_relative '../spec_helper'

RSpec.describe Trip do
  describe "attributes" do
    it "returns value in duration column" do
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 2,
                                start_date: "2012-8-12",
                                end_date: "2012-8-12",
                                bike_id: 122,
                                zip_code: 80218)

      expect(trip.duration).to eq(400)
      expect(trip.start_station_id).to eq(1)
      expect(trip.end_station_id).to eq(2)
      expect(trip.start_date.day).to eq(12)
      expect(trip.end_date.day).to eq(12)
      expect(trip.bike_id).to eq(122)
      expect(trip.zip_code).to eq(80218)
    end
  end

    describe "validations" do
      it "is invalid without a duration" do
        subscription = SubscriptionType.create(name: "Customer")
        trip = subscription.trips.create(start_station_id: 1,
                                  end_station_id: 2,
                                  start_date: "2012-8-12",
                                  end_date: "2012-8-12",
                                  bike_id: 122,
                                  zip_code: 80218)
      expect(trip).to_not be_valid
    end

    it "is invalid without a start_date" do
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 2,
                                end_date: "2012-8-12",
                                bike_id: 122,
                                zip_code: 80218)
      expect(trip).to_not be_valid
    end

    it "is invalid without a start_station_id" do
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                end_station_id: 2,
                                start_date: "2012-8-12",
                                end_date: "2012-8-12",
                                bike_id: 122,
                                zip_code: 80218)
      expect(trip).to_not be_valid
    end

    it "is invalid without a end_date" do
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 2,
                                start_date: "2012-8-12",
                                bike_id: 122,
                                zip_code: 80218)
      expect(trip).to_not be_valid
    end

    it "is invalid without a end_station_id" do
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                start_station_id: 1,
                                start_date: "2012-8-12",
                                end_date: "2012-8-12",
                                bike_id: 122,
                                zip_code: 80218)
      expect(trip).to_not be_valid
    end

    it "is invalid without a bike_id" do
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 2,
                                start_date: "2012-8-12",
                                end_date: "2012-8-12",
                                zip_code: 80218)
      expect(trip).to_not be_valid
    end

    it "is invalid without a subscription_type_id" do
      trip = Trip.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 2,
                                start_date: "2012-8-12",
                                end_date: "2012-8-12",
                                bike_id: 122,
                                zip_code: 80218)
      expect(trip).to_not be_valid
    end

    it "is valid without a zip_code" do
      subscription = SubscriptionType.create(name: "Customer")
      trip = subscription.trips.create(duration: 400,
                                start_station_id: 1,
                                end_station_id: 2,
                                start_date: "2012-8-12",
                                end_date: "2012-8-12",
                                bike_id: 122)
      expect(trip).to be_valid
    end
  end
end
