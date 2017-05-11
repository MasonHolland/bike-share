require_relative '../spec_helper'

RSpec.describe 'when a user visits the all stations page' do
  it 'they can see stations' do
    city = City.create(name: "San Jose")
    city.stations.create!(name: "MLK", dock_count: 22, installation_date: "1999-9-11")

    visit('/stations')
    click_on "View Stations"

    expect(page).to have_content("MLK")
    expect(current_path).to eq('/stations/view_all')
  end
end
