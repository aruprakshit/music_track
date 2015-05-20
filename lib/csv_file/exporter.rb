module CsvFile
  class Exporter
    def initialize query, path
      @query = query
      @path_to_file = path
    end

    def export
      conn = ActiveRecord::Base.connection
      conn.execute("COPY ( #{@query.strip} ) TO '#{@path_to_file}' CSV HEADER ;")
    end
  end
end
