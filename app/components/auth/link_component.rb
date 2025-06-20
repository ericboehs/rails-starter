class Auth::LinkComponent < ViewComponent::Base
  def initialize(text:, url:, centered: true)
    @text = text
    @url = url
    @centered = centered
  end

  private

  attr_reader :text, :url, :centered

  def wrapper_classes
    base_classes = "text-sm"
    base_classes += " text-center" if centered
    base_classes
  end

  def link_classes
    "font-semibold text-emerald-600 dark:text-emerald-400 hover:text-emerald-500 dark:hover:text-emerald-300"
  end
end
