namespace :ftp do

  directory Rails.root.join("tmp/zip")

  desc "download files from FTP server"
  # pass the environment task name to load your rails app. Like
  # RAILS_ENV=development bin/rake ftp:download
  task download: [ :environment, Rails.root.join("tmp/zip") ]  do
    connection = FTPConnector.new
    connection.download_data Date.today.strftime("%Y%m%d"), Rails.root.join("tmp/zip"), match_patterns: [ "R_C_*.txt.gz", "R_D_*.txt.gz" ]
    puts "Downloaded files...."
  end
end
