module Storage
  class FileNotFound < StandardError;end

  class File
    attr_reader :path_to_file
    def initialize dir, filename
      @path_to_file = dir.join(filename)
    end

    def create!
      FileUtils.touch @path_to_file
    end

    def apply_permissions permission
      FileUtils.chmod permission, @path_to_file
    end
  end
end
