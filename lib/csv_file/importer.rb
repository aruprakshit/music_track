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
      columns_t1 = self.singleton_class.fields.map { |f| "t1.#{f}" }.join(",")
      columns_t2 = self.singleton_class.fields.map { |f| "t2.#{f}" }.join(",")
      ActiveRecord::Base.transaction do
        conn = ActiveRecord::Base.connection
        conn.execute "CREATE TEMP TABLE tmp_table AS SELECT * FROM #{table.strip}; "
        conn.execute("COPY tmp_table ( #{self.singleton_class.fields.join(',') } ) FROM '#{source_file}' CSV HEADER DELIMITER '\t' QUOTE '|' ;")
        conn.execute "INSERT INTO #{table.strip} ( #{self.singleton_class.fields.join(',')} ) SELECT DISTINCT #{columns_t1} FROM tmp_table t1 WHERE NOT EXISTS ( SELECT 1 FROM #{table.strip} t2 WHERE (#{columns_t2}) IS NOT DISTINCT FROM (#{columns_t1}) );"
        conn.execute "DROP TABLE IF EXISTS tmp_table;"
      end
    end

    def import_dir!(source_dir)
      Pathname.new(source_dir).children.each do |p|
        import!(p)
      end
    end
  end
end
