module Storage
  class DirectoryNotFound < StandardError;end

  class Directory
    attr_reader :path_to_dir

    def initialize source_dir, target_dir
      @path_to_dir = source_dir.join(target_dir)
    end

    def create!
      FileUtils.mkdir_p @path_to_dir
    end
  end
end
