require_relative '../spec_helper'

RSpec.describe "user can fill in form" do
  it "it updates page with correct information" do
      city = City.create(name: "Washington DC")
      City.create(name: "Frankfurt")
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
      city.stations.create!(name: "MLK", dock_count: 32, installation_date: "1984-05-24")

      visit('/stations/1/edit')
      fill_in "station[name]", with: "Malcolm X"
      select("Tokyo", :from => "city[name]")
      click_button "Submit changes"
      expect(current_path).to eq('/stations/1')
      expect(page).to have_content("Malcolm X")
      expect(page).to have_content("Tokyo")
  end
end
