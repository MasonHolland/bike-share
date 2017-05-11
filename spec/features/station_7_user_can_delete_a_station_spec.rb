require_relative '../spec_helper'

RSpec.describe "user can delete a station" do
  it "takes you to view all page and entry is deleted" do
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
    city.stations.create(name: "MLK", dock_count: 35, installation_date: "2010-11-12")
    city.stations.create(name: "Malcolm X", dock_count: 35, installation_date: "2011-12-11")

    visit("/stations/1")

    click_on "Delete"
    expect(current_path).to eq("/stations/view_all")
    expect(page).to_not have_content("MLK")
  end
end
