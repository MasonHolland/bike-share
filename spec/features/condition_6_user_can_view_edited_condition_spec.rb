require_relative '../spec_helper'

RSpec.describe "user can fill in form" do
  it "it updates page with correct information" do
    ride_date = RideDate.create(day: 12, month: 8, year: 2012)
    condition = Condition.create(ride_date_id:      1,
                                 max_temperature:   95,
                                 mean_temperature:  80,
                                 min_temperature:   60,
                                 mean_humidity:     70,
                                 mean_visibility:   12,
                                 mean_wind_speed:   11,
                                 precipitation:     "T")

    visit('/conditions/1/edit')
    fill_in "condition[ride_date_id]", with: "2017-10-7"
    fill_in "condition[max_temperature]", with: "70"
    fill_in "condition[min_temperature]", with: "50"
    fill_in "condition[mean_humidity]", with: "20"
    fill_in "condition[mean_wind_speed]", with: "22"
    click_button "Submit changes"
    
    expect(current_path).to eq('/conditions/1')
    expect(page).to have_content("22")
    expect(page).to have_content("70")
  end
end
