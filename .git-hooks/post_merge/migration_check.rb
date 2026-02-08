# frozen_string_literal: true

module Overcommit::Hook::PostMerge
  # Warns about pending database migrations after merging.
  class MigrationCheck < Base
    def run
      result = execute(%w[ bin/rails db:migrate:status ], env: { "RAILS_ENV" => "development" })
      return :pass unless result.success?
      return :pass unless result.stdout.include?("down")

      [ :warn, "You have pending migrations. Run `bin/rails db:migrate` to update your database." ]
    end
  end
end
