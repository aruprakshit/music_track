module CsvFile
  class Importer
    def initialize table, source_file, fields
      @table = table
      @source_file = source_file
      @fields = fields.join(",")
    end

    def import
      conn = ActiveRecord::Base.connection
      conn.execute("COPY #{@table.strip} ( #{@fields} ) FROM '#{@source_file}' CSV HEADER DELIMITER '\t' QUOTE '|' ;")
    end
  end
end
