# frozen_string_literal: true

class Auth::ButtonComponent < ViewComponent::Base
  include ButtonStyling

  def initialize(text:, type: :submit, variant: :primary, **options)
    @text = text
    @type = type
    @variant = variant
    @options = options
  end

  private

  attr_reader :text, :type, :variant, :options

  def button_classes
    extra_classes = options.delete(:class) || ""
    build_button_classes(variant: variant, extra_classes: extra_classes)
  end
end
