module CsvFile
  class Importer
    def initialize table: table=nil
      @table = table
      # if there's no table, default to the model's plural
      # @fields = fields.join(",")
    end

    def table
      @table || self.singleton_class.model.to_s.downcase.pluralize
    end

    def import!(source_file)
      conn = ActiveRecord::Base.connection
      conn.execute("COPY #{table.strip} ( #{self.singleton_class.fields.join(',') } ) FROM '#{source_file}' CSV HEADER DELIMITER '\t' QUOTE '|' ;")
    end

    def import_dir!(source_dir)
      Pathname.new(source_dir).children.each do |p|
        import!(p)
      end
    end
  end
end
