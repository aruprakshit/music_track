module Storage
  class FileNotFound < StandardError;end

  class File
    def initialize dir, filename
      @path_to_file = dir.join(filename)
    end

    def create!
      FileUtils.touch @path_to_file
      self
    end

    def with_permissions permission
      raise FileNotFound unless File.exist? @path_to_file
      FileUtils.chmod permission, @path_to_file
    end
  end
end
