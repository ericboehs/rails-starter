# frozen_string_literal: true

# Renders styled form inputs with labels and error states for authentication forms
class Auth::InputComponent < ViewComponent::Base
  def initialize(form:, field:, **options)
    @form = form
    @field = field
    @options = options
  end

  private

  attr_reader :form, :field, :options

  def label
    options[:label]
  end

  def error
    options[:error]
  end

  def type
    options[:type] || :text
  end

  def required
    options[:required] || false
  end

  def autocomplete
    options[:autocomplete]
  end

  def placeholder
    options[:placeholder]
  end

  def forgot_password_link
    options[:forgot_password_link]
  end

  def input_classes
    base_classes = "block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-emerald-600 sm:text-sm/6"
    dark_classes = "dark:bg-white/5 dark:text-white dark:placeholder:text-gray-500 dark:outline-white/10 dark:focus:outline-emerald-500"

    if error
      "#{base_classes} #{dark_classes} outline-red-300 dark:outline-red-400/50 placeholder:text-red-300 dark:placeholder:text-red-400 focus:outline-red-600 dark:focus:outline-red-500"
    else
      "#{base_classes} #{dark_classes}"
    end
  end

  def field_id
    "#{field}_#{object_id}"
  end

  def label_text
    label || t("auth.sign_in.#{field}_label", default: field.to_s.humanize)
  end
end
