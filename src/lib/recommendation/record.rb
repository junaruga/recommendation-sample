require 'json'

module Recommendation
  class Record

    DATA_DIR = '../../data'

    def initialize(table_name)
      @table_name = table_name
    end

    def each(&block)
      path = json_file_path;
      open(path) do |file|
         while line = file.gets
           if line.empty?
             next
           end
           row = JSON.parse(line)
           block.call(row)
         end
      end
    end

    def find_one(primary_id)
      if primary_id.nil?
        raise ArgumentError.new("primary_id is required.")
      end

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
      file_name = "%s.json" % @table_name
      File.join(DATA_DIR, file_name)
    end
  end
end
