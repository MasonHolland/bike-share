require_relative '../spec_helper'

RSpec.describe "user can click the submit button on a form" do
  it "will redirect to the page for that individual condition" do
    visit('/conditions/new')
    fill_in "condition[ride_date_id]", with: "2017-5-12"
    fill_in "condition[max_temperature]", with: "70"
    fill_in "condition[mean_temperature]", with: "60"
    fill_in "condition[min_temperature]", with: "50"
    fill_in "condition[mean_humidity]", with: "20"
    fill_in "condition[mean_visibility]", with: "2"
    fill_in "condition[mean_wind_speed]", with: "10"
    fill_in "condition[precipitation]", with: "12"
    click_on "Submit"

    expect(current_path).to eq("/conditions/1")
    expect(page).to have_content("10")
    expect(page).to have_content("12")
  end
end
