require_relative '../spec_helper'

RSpec.describe "when a user visits the edit page" do
  it "displays an edit form" do
    city = City.create(name: "Denver")
    City.create(name: "DC")
    City.create(name: "New York")
    city = City.create(name: "Vancover")
    StartStation.create(station_id: 1)
    EndStation.create(station_id: 1)
    subscription_type = SubscriptionType.create(name: "Customer")
    ride_date = RideDate.find_or_create_by(day: 12, month: 8, year: 2012)
    StartDate.create(ride_date_id: 1)
    EndDate.create(ride_date_id: 1)
    trip = subscription_type.trips.create(duration: 400,
                              start_station_id: 1,
                              end_station_id: 1,
                              start_date_id: 1,
                              end_date_id: 1,
                              bike_id: 122,
                              zip_code: 80218)
    city.stations.create!(name: "MLK", dock_count: 22, installation_date: "2013-11-12")

    visit("/stations/1")
    click_on "Edit"

    expect(current_path).to eq("/stations/1/edit")
    expect(page).to have_content("change")
    expect(page).to have_content("MLK")
  end
end
