require_relative '../spec_helper'

RSpec.describe "when user visits station dashboard" do
  it "displays all relevant stats" do
    city = City.create(name: "San Jose")
    city.stations.create(name: "MLK Station", dock_count: 19, city_id: 1, installation_date: "2013-5-11")
    city.stations.create(name: "Cesar Chavez Station", dock_count: 5, city_id: 1, installation_date: "2013-5-19")
    StartStation.create(station_id: 2)
    StartStation.create(station_id: 1)
    EndStation.create(station_id: 2)
    EndStation.create(station_id: 1)
    SubscriptionType.create(name: "Subscriber")
    subscription_type = SubscriptionType.create(name: "Customer")
    RideDate.find_or_create_by(day: 12, month: 8, year: 2012)
    StartDate.create(ride_date_id: 1)
    EndDate.create(ride_date_id: 1)
    subscription_type.trips.create(duration: 400,
                                  start_station_id: 1,
                                  end_station_id: 2,
                                  start_date_id: 1,
                                  end_date_id: 1,
                                  bike_id: 122,
                                  zip_code: 80218)
    subscription_type.trips.create(duration: 5,
                                  start_station_id: 2,
                                  end_station_id: 2,
                                  start_date_id: 1,
                                  end_date_id: 1,
                                  bike_id: 800,
                                  zip_code: 80219)

    visit('/trips-dashboard')

    expect(page).to have_content("Average duration of a ride: 203")
    expect(page).to have_content("Longest ride: ID# 1")
    expect(page).to have_content("Shortest ride: ID# 2")
    expect(page).to have_content("Station with the most rides as a starting place: MLK Station")
    expect(page).to have_content("Station with the most rides as an ending place: Cesar Chavez Station")
    expect(page).to have_content("Most ridden bike with total number of rides for that bike: Bike ID: 800 Trips Taken: 1")
    expect(page).to have_content("Least ridden bike with total number of rides for that bike: Bike ID: [122, 800] Trips Taken: 1")
    expect(page).to have_content("User subscription type breakout with both count and percentage: Subscriber Total users: 0 Percentage of users: 0% Customer Total users: 2 Percentage of users: 100%")
    expect(page).to have_content("Single date with the highest number of trips with a count of those trips: 8/12/2012 - 2")
    expect(page).to have_content("Single date with the lowest number of trips with a count of those trips: 8/12/2012 - 2")
  end
end
