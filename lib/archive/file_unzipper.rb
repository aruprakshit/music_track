module Archive
  class FileUnzipper
    def initialize source_path, dest_path
      @source_path = source_path
      @dest_path   = dest_path
    end

    def zip!
      Zip::File.open(@source_path) do |zip_file|
        zip_file.each do |entry|
          puts "Unzipping the file: #{entry}"
          zip_file.extract(entry, prepare_destination_dir(entry.name)) { true }
        end
      end
    end

    private

    def prepare_destination_dir dir
      FileUtils.mkdir_p(@dest_path.join(dir).dirname)
      @dest_path.join(dir)
    end
  end
end
