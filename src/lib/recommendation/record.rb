#!/usr/bin/env ruby
# coding: utf-8

require 'json'

module Recommendation
  class Record

    DATA_DIR = '../../data'

    def initialize(table_name)
      @table_name = table_name
    end

    def each(&block)
      path = json_file_path;
      open(path) { |file|
         while line = file.gets
           if line == ""
             next
           end
           row = JSON.parse(line)
           block.call(row)
         end
      }
    end

    def findOne(primary_id)
      result = {}
      each do |row|
        if row.key?('id') and row['id'] == primary_id
          result = row
          break
        end
      end
      result
    end

    private

    def json_file_path
      "#{DATA_DIR}/#{@table_name}.json"
    end
  end
end
