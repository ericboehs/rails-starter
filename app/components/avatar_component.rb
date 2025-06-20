class AvatarComponent < ViewComponent::Base
  def initialize(user:, size: 8, text_size: "sm")
    @user = user
    @size = size
    @text_size = text_size
  end

  private

  attr_reader :user, :size, :text_size

  def size_classes
    "size-#{size} rounded-full"
  end

  def text_classes
    "text-#{text_size} font-medium text-white hidden"
  end
end
