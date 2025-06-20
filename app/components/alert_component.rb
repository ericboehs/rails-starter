# frozen_string_literal: true

class AlertComponent < ViewComponent::Base
  def initialize(message: nil, messages: nil, type: :info, dismissible: false)
    @message = message
    @messages = messages
    @type = type
    @dismissible = dismissible
  end

  private

  attr_reader :message, :messages, :type, :dismissible

  def has_list?
    messages && messages.any?
  end

  def alert_classes
    base_classes = "rounded-md p-4"

    case type
    when :success
      "#{base_classes} bg-green-50 dark:bg-green-900/50"
    when :error, :alert
      "#{base_classes} bg-red-50 dark:bg-red-900/50"
    when :warning
      "#{base_classes} bg-yellow-50 dark:bg-yellow-900/50"
    when :info
      "#{base_classes} bg-blue-50 dark:bg-blue-900/50"
    else
      "#{base_classes} bg-gray-50 dark:bg-gray-900/50"
    end
  end

  def icon_classes
    case type
    when :success
      "size-5 text-green-400 dark:text-green-300"
    when :error, :alert
      "size-5 text-red-400 dark:text-red-300"
    when :warning
      "size-5 text-yellow-400 dark:text-yellow-300"
    when :info
      "size-5 text-blue-400 dark:text-blue-300"
    else
      "size-5 text-gray-400 dark:text-gray-300"
    end
  end

  def text_classes
    case type
    when :success
      "text-sm font-medium text-green-800 dark:text-green-200"
    when :error, :alert
      "text-sm font-medium text-red-800 dark:text-red-200"
    when :warning
      "text-sm font-medium text-yellow-800 dark:text-yellow-200"
    when :info
      "text-sm font-medium text-blue-800 dark:text-blue-200"
    else
      "text-sm font-medium text-gray-800 dark:text-gray-200"
    end
  end

  def dismiss_button_classes
    case type
    when :success
      "inline-flex rounded-md bg-green-50 dark:bg-green-900/50 p-1.5 text-green-500 dark:text-green-400 hover:bg-green-100 dark:hover:bg-green-800/50 focus:ring-2 focus:ring-emerald-600 focus:ring-offset-2 focus:ring-offset-green-50 dark:focus:ring-offset-green-900/50 focus:outline-hidden"
    when :error, :alert
      "inline-flex rounded-md bg-red-50 dark:bg-red-900/50 p-1.5 text-red-500 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-800/50 focus:ring-2 focus:ring-emerald-600 focus:ring-offset-2 focus:ring-offset-red-50 dark:focus:ring-offset-red-900/50 focus:outline-hidden"
    when :warning
      "inline-flex rounded-md bg-yellow-50 dark:bg-yellow-900/50 p-1.5 text-yellow-500 dark:text-yellow-400 hover:bg-yellow-100 dark:hover:bg-yellow-800/50 focus:ring-2 focus:ring-emerald-600 focus:ring-offset-2 focus:ring-offset-yellow-50 dark:focus:ring-offset-yellow-900/50 focus:outline-hidden"
    when :info
      "inline-flex rounded-md bg-blue-50 dark:bg-blue-900/50 p-1.5 text-blue-500 dark:text-blue-400 hover:bg-blue-100 dark:hover:bg-blue-800/50 focus:ring-2 focus:ring-emerald-600 focus:ring-offset-2 focus:ring-offset-blue-50 dark:focus:ring-offset-blue-900/50 focus:outline-hidden"
    else
      "inline-flex rounded-md bg-gray-50 dark:bg-gray-900/50 p-1.5 text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800/50 focus:ring-2 focus:ring-emerald-600 focus:ring-offset-2 focus:ring-offset-gray-50 dark:focus:ring-offset-gray-900/50 focus:outline-hidden"
    end
  end

  def icon_svg
    case type
    when :success
      # Check circle icon
      '<svg class="' + icon_classes + '" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.857-9.809a.75.75 0 0 0-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5Z" clip-rule="evenodd" />
      </svg>'
    when :error, :alert
      # X circle icon
      '<svg class="' + icon_classes + '" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16ZM8.28 7.22a.75.75 0 0 0-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 1 0 1.06 1.06L10 11.06l1.72 1.72a.75.75 0 1 0 1.06-1.06L11.06 10l1.72-1.72a.75.75 0 0 0-1.06-1.06L10 8.94 8.28 7.22Z" clip-rule="evenodd" />
      </svg>'
    when :warning
      # Exclamation triangle icon
      '<svg class="' + icon_classes + '" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path fill-rule="evenodd" d="M8.485 2.495c.673-1.167 2.357-1.167 3.03 0l6.28 10.875c.673 1.167-.17 2.625-1.516 2.625H3.72c-1.347 0-2.189-1.458-1.515-2.625L8.485 2.495ZM10 5a.75.75 0 0 1 .75.75v3.5a.75.75 0 0 1-1.5 0v-3.5A.75.75 0 0 1 10 5Zm0 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd" />
      </svg>'
    when :info
      # Information circle icon
      '<svg class="' + icon_classes + '" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-7-4a1 1 0 1 1-2 0 1 1 0 0 1 2 0ZM9 9a.75.75 0 0 0 0 1.5h.253a.25.25 0 0 1 .244.304l-.459 2.066A1.75 1.75 0 0 0 10.747 15H11a.75.75 0 0 0 0-1.5h-.253a.25.25 0 0 1-.244-.304l.459-2.066A1.75 1.75 0 0 0 9.253 9H9Z" clip-rule="evenodd" />
      </svg>'
    else
      # Generic circle icon for unknown types
      '<svg class="' + icon_classes + '" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z" clip-rule="evenodd" />
      </svg>'
    end
  end
end
