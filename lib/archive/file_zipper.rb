module Archive
  class FileZipper
    def initialize source_path, dest_path
      @source_path = source_path
      @dest_path   = dest_path
    end

    def zip!
      Zip::File.open(@source_path) do |zip_file|
        zip_file.each do |entry|
          puts "Unzipping the file: #{entry}"
          destination_dir = @dest_path.join(entry.name)
          FileUtils.mkdir_p destination_dir.dirname
          zip_file.extract(entry, destination_dir) { true }
        end
      end
    end
  end
end
