class UserPageComponent < ViewComponent::Base
  def initialize(title_key:)
    @title_key = title_key
  end

  private

  attr_reader :title_key
end
