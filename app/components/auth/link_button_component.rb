# frozen_string_literal: true

class Auth::LinkButtonComponent < ViewComponent::Base
  include ButtonStyling

  def initialize(text:, url:, variant: :primary, **options)
    @text = text
    @url = url
    @variant = variant
    @options = options
  end

  private

  attr_reader :text, :url, :variant, :options

  def button_classes
    extra_classes = options.delete(:class) || ""
    build_button_classes(variant: variant, extra_classes: extra_classes, include_flex: true)
  end
end
