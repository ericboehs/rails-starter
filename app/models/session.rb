# Represents a user's authentication session
class Session < ApplicationRecord
  belongs_to :user
end
