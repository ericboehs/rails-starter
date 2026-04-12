# Renders styled text links for authentication pages
class Auth::LinkComponent < ViewComponent::Base
  def initialize(text:, url:, align: :center)
    @text = text
    @url = url
    @align = align
  end

  private

  attr_reader :text, :url, :align

  def wrapper_classes
    base_classes = "text-sm"
    base_classes += " text-center" if align == :center
    base_classes
  end

  def link_classes
    "font-semibold text-emerald-600 dark:text-emerald-400 hover:text-emerald-500 dark:hover:text-emerald-300"
  end
end
