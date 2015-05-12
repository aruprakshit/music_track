require 'net/ftp'

class FTPConnector

  def initialize
    @username = ENV['ftp_username']
    @password = ENV['ftp_password']
    @host     = ENV['ftp_ip']
    @root_dir  = ENV['ftp_root_dir']
  end

  def connect
    @connect = Net::FTP::new(@host, @username, @password)
    @connect.chdir(@root_dir)
    @connect
  end

  def download dest_file_path
    connect
    file_list = connect.nlst('*.zip')
    file_list.each do |file_name|
      puts "Fetching the file: #{file_name}"
      connect.getbinaryfile(file_name, dest_file_path.join(File.basename(file_name)))
    end
    connect.close
  end
end
