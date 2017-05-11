class Condition < ActiveRecord::Base
  belongs_to :ride_date

  validates :ride_date_id, presence: true
  validates :max_temperature, presence: true
  validates :mean_temperature, presence: true
  validates :min_temperature, presence: true
  validates :mean_humidity, presence: true
  validates :mean_visibility, presence: true
  validates :mean_wind_speed, presence: true
  validates :precipitation, presence: true
end
