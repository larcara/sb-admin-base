class Setting < ActiveRecord::Base
  scope :active, -> {where(status: ["active", nil])}
end
