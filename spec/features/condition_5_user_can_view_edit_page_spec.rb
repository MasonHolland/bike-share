require_relative '../spec_helper'

RSpec.describe "when a user visits the edit page" do
  it "displays an edit form" do
    RideDate.create(day: 12, month: 8, year: 2012)
    Condition.create(ride_date_id:      1,
                                 max_temperature:   95,
                                 mean_temperature:  80,
                                 min_temperature:   60,
                                 mean_humidity:     70,
                                 mean_visibility:   12,
                                 mean_wind_speed:   11,
                                 precipitation:     "T")
    visit("/conditions/1")
    click_on "Edit"

    expect(current_path).to eq("/conditions/1/edit")
    expect(page).to have_content("change")
    expect(page).to have_content("Max Temperature")
  end
end
