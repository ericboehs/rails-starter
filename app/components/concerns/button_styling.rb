# frozen_string_literal: true

# Provides shared button styling methods with variant support
module ButtonStyling
  extend ActiveSupport::Concern

  VARIANT_CLASSES = {
    primary: "bg-emerald-600 dark:bg-emerald-500 text-white hover:bg-emerald-500 dark:hover:bg-emerald-400 focus-visible:outline-emerald-600 dark:focus-visible:outline-emerald-500",
    secondary: "bg-white dark:bg-white/10 text-gray-900 dark:text-white shadow-none inset-ring inset-ring-gray-300 dark:inset-ring-white/10 hover:bg-gray-50 dark:hover:bg-white/20",
    danger: "bg-red-600 text-white hover:bg-red-500 focus-visible:outline-red-600"
  }.freeze

  private

  def button_base_classes
    "rounded-md px-3 py-1.5 text-sm/6 font-semibold shadow-xs focus-visible:outline-2 focus-visible:outline-offset-2"
  end

  def build_button_classes(variant:, extra_classes: "")
    [ button_base_classes, VARIANT_CLASSES[variant], extra_classes ].join(" ").strip
  end

  def build_flex_button_classes(variant:, extra_classes: "")
    base = "inline-flex items-center #{button_base_classes}"
    [ base, VARIANT_CLASSES[variant], extra_classes ].join(" ").strip
  end
end
