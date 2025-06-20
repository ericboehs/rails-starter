# frozen_string_literal: true

class Auth::FormContainerComponent < ViewComponent::Base
  def initialize(title_key:, subtitle_key: nil, title: nil, subtitle: nil)
    @title_key = title_key
    @subtitle_key = subtitle_key
    @title = title
    @subtitle = subtitle
  end

  private

  attr_reader :title_key, :subtitle_key, :title, :subtitle

  def title_text
    title || (title_key ? t(title_key) : nil)
  end

  def subtitle_text
    subtitle || (subtitle_key ? t(subtitle_key) : nil)
  end
end
