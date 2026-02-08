# frozen_string_literal: true

module Overcommit::Hook::PostCheckout
  # Warns when the bundle is out of date after switching branches.
  class BundleCheck < Base
    def run
      result = execute(%w[ bundle check ])
      return :pass if result.success?

      [ :warn, "Bundle is not up to date. Run `bundle install` to update." ]
    end
  end
end
