require 'net/ftp'

class FTPConnector

  def initialize
    @username = ENV['ftp_username']
    @password = ENV['ftp_password']
    @host     = ENV['ftp_ip']
    @root_dir  = ENV['ftp_root_dir']
  end

  def connect
    @ftp = Net::FTP::new(@host, @username, @password)
    @ftp.chdir(@root_dir)
    @ftp
  end


  # downloads data from a path into a destination path
  # match pattern is the pattern we'd like to match
  # the data should be present in our destination_path
  # once this method is done running
  # it is synchronous by default
  # by default we don't want to overwrite the data we have
  # because the data files for one day should not change
  def download_data(download_from_paths, destination_path,
                    match_patterns: "*.txt.gz", overwrite: false)

    connect
    puts "current directory: #{@ftp.pwd}"
    puts download_from_paths
    download_from_paths.each do | download_from_path |
      @ftp.chdir(download_from_path)
      file_list = match_patterns.map { |match_pattern | @ftp.nlst(match_pattern) }
      file_list.each do |file_name|
        # destination file name should be the same as the original file name
        destination_file_name = destination_path + "/" + File.basename(file_name)

        # write the file if we want to overwrite or if it doesn't already exist
        if overwrite || exists = !File.exists?(destination_file_name)
          puts "Downloading file: #{file_name}"

          # make sure to delete the file first so we can overwrite if needed
          Pathname.new(file_name).unlink if exists
          @ftp.getbinaryfile(file_name, destination_file_name)
        end
      end
      @ftp.chdir("..")
    end

    @ftp.close
  end
end
