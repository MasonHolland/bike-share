require_relative '../spec_helper'

RSpec.describe "user can delete a station" do
  it "takes you to view all page and entry is deleted" do
    ride_date = RideDate.create(day: 12, month: 8, year: 2012)
    condition = Condition.create(ride_date_id:      1,
                                 max_temperature:   95,
                                 mean_temperature:  80,
                                 min_temperature:   60,
                                 mean_humidity:     70,
                                 mean_visibility:   12,
                                 mean_wind_speed:   11,
                                 precipitation:     "T")
    visit("/conditions/1")

    click_on "Delete"
    expect(current_path).to eq("/conditions/view_all")
    expect(page).to_not have_content("2013-11-22")
  end
end
