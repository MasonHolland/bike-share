require_relative '../spec_helper'

RSpec.describe Condition do
  describe "attributes" do
    it "returns value in name column" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")
      expect(condition.ride_date_id).to eq(1)
      expect(condition.max_temperature).to eq(95)
      expect(condition.mean_temperature).to eq(80)
      expect(condition.min_temperature).to eq(60)
      expect(condition.mean_humidity).to eq(70)
      expect(condition.mean_visibility).to eq(12)
      expect(condition.mean_wind_speed).to eq(11)
      expect(condition.precipitation).to eq("T")
    end
  end

  describe "condition can get ride date information" do
    it "will find correct date" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")

      expect(condition.ride_date.day).to eq(12)
      expect(condition.ride_date.month).to eq(8)
      expect(condition.ride_date.year).to eq(2012)
    end
  end

  describe "validations" do
    it "is invalid without a ride date id" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      nil,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")

      expect(condition).to_not be_valid
    end

    it "is invalid without max temperature" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")
      expect(condition).to_not be_valid
    end

    it "is invalid without a mean temperature" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")
      expect(condition).to_not be_valid
    end

    it "is invalid without a min temperature" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")
      expect(condition).to_not be_valid
    end

    it "is invalid without a mean humidity" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")
      expect(condition).to_not be_valid
    end
    it "is invalid without a mean visibility" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_wind_speed:   11,
                                   precipitation:     "T")
      expect(condition).to_not be_valid
    end
    it "is invalid without a mean wind speed" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   precipitation:     "T")
      expect(condition).to_not be_valid
    end
    it "is invalid without a precipitation" do
      ride_date = RideDate.create(day: 12, month: 8, year: 2012)
      condition = Condition.create(ride_date_id:      1,
                                   max_temperature:   95,
                                   mean_temperature:  80,
                                   min_temperature:   60,
                                   mean_humidity:     70,
                                   mean_visibility:   12,
                                   mean_wind_speed:   11)

      expect(condition).to_not be_valid
    end
  end
end
