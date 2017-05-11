require_relative '../spec_helper'

RSpec.describe 'when a user visits the all conditions page' do
  it 'they can see conditions' do
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
    click_on "View Conditions"
    expect(page).to have_content("70")
    expect(current_path).to eq('/conditions/view_all')
  end
end
