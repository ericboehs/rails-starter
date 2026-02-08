# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  # Checks that all files end with a final newline character.
  class FinalNewline < Base
    def run
      applicable_files.filter_map do |file|
        next if File.size(file).zero?

        "#{file}: No newline at end of file" unless File.binread(file).end_with?("\n")
      end.map { |msg| Overcommit::Hook::Message.new(:error, nil, nil, msg) }
    end
  end
end
