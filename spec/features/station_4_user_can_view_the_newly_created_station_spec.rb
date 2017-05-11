require_relative '../spec_helper'

RSpec.describe "user can click the submit button on a form" do
  it "will redirect to the page for that individual station" do
    City.create(name: "Rockville")
    City.create(name: "Tokyo")
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

    visit('/stations/new')
    fill_in "station[name]", with: "MLK"
    fill_in "station[dock_count]", with: 22
    select("Tokyo", :from => "city[name]")
    fill_in "station[installation_date]", with: "1776-9-12"
    click_on "Submit"

    expect(current_path).to eq("/stations/1")
    expect(page).to have_content("Tokyo")
    expect(page).to have_content("MLK")
  end
end
