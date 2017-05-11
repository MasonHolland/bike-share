class StartDate < ActiveRecord::Base
  belongs_to :ride_date
  has_many :trips

  validates :ride_date_id, presence: true
end
