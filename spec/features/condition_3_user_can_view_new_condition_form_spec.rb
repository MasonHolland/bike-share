require_relative '../spec_helper'

RSpec.describe "user can see form for creating a new station" do
  it "will display the correct empty form" do
    ride_date = RideDate.create(day: 12, month: 8, year: 2012)
    condition = Condition.create(ride_date_id:      1,
                                 max_temperature:   95,
                                 mean_temperature:  80,
                                 min_temperature:   60,
                                 mean_humidity:     70,
                                 mean_visibility:   12,
                                 mean_wind_speed:   11,
                                 precipitation:     "T")

    visit('/conditions')
    click_on "Create New Weather Condition"

    expect(page).to have_content("Create New Weather Condition")
  end
end
