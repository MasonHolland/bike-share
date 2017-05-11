require_relative '../spec_helper'

RSpec.describe 'use can view an individual conditions page' do
  it 'will display correct conditions page' do
    ride_date = RideDate.create(day: 12, month: 8, year: 2012)
    condition = Condition.create(ride_date_id:      1,
                                 max_temperature:   95,
                                 mean_temperature:  80,
                                 min_temperature:   60,
                                 mean_humidity:     70,
                                 mean_visibility:   12,
                                 mean_wind_speed:   11,
                                 precipitation:     "T")

    visit("/conditions/view_all")
    click_on "Additional Info"

    expect(current_path).to eq("/conditions/1")
    expect(page).to have_content("70")
    expect(page).to have_content("Edit")
  end
end
