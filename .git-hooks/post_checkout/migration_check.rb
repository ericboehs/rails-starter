# frozen_string_literal: true

module Overcommit::Hook::PostCheckout
  # Warns about pending database migrations after switching branches.
  class MigrationCheck < Base
    def run
      return :pass unless migrations_pending?

      [ :warn, "You have pending migrations. Run `bin/rails db:migrate` to update your database." ]
    end

    private

    def migrations_pending?
      result = execute(%w[ bin/rails db:migrate:status ], env: { "RAILS_ENV" => "development" })
      result.success? && result.stdout.include?("down")
    end
  end
end
