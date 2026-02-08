# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  # Checks that all files end with a final newline character.
  class FinalNewline < Base
    def run
      text_files.filter_map do |file|
        next if File.size(file).zero?

        "#{file}: No newline at end of file" unless ends_with_newline?(file)
      end.map { |msg| Overcommit::Hook::Message.new(:error, nil, nil, msg) }
    end

    private

    def ends_with_newline?(file)
      File.open(file, "rb") { |f| f.seek(-1, IO::SEEK_END); f.read(1) == "\n" }
    end

    def text_files
      result = execute(%w[git ls-files --eol -z --], args: applicable_files)
      return applicable_files unless result.success?

      result.stdout.split("\0").filter_map do |file_info|
        info, path = file_info.split("\t")
        next if info.include?("-text")

        path
      end
    end
  end
end
