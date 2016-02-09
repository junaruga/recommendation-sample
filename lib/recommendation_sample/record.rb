require 'json'

module RecommendationSample
  # This program manages json files under the DATA_DIR as object.
  # Inspired by Rails ActiveRecord.
  class Record
    DATA_DIR = File.expand_path(
      File.join(File.dirname(__FILE__), '..', '..', 'data'))

    attr_accessor :table_name

    def initialize(table_name)
      @table_name = table_name
    end

    def each
      path = json_file_path
      open(path) do |file|
        while (line = file.gets)
          next if line.empty?
          row = JSON.parse(line)
          yield(row)
        end
      end
    end

    def find_one(primary_id)
      fail ArgumentError 'primary_id is required.' if primary_id.nil?

      result = {}
      each do |row|
        if row['id'] == primary_id
          result = row
          break
        end
      end
      result
    end

    private

    def json_file_path
      file_name = format('%s.json', @table_name)
      File.join(DATA_DIR, file_name)
    end
  end
end
