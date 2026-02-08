# frozen_string_literal: true

module Overcommit::Hook::PostRewrite
  # Warns when the bundle is out of date after a rebase.
  class BundleCheck < Base
    def run
      result = execute(%w[ bundle check ])
      return :pass if result.success?

      [ :warn, "Bundle is not up to date. Run `bundle install` to update." ]
    end
  end
end
