namespace :ftp do

  directory Rails.root.join("tmp/zip")

  desc "download files from FTP server"
  # pass the environment task name to load your rails app. Like
  # RAILS_ENV=development bin/rake ftp:download
  task download: [ :environment, Rails.root.join("tmp/zip") ]  do
    connection = FTPConnector.new
    connection.download Rails.root.join("tmp/zip")
    puts "Downloaded files\n #{Dir::glob(Rails.root.join('tmp/zip/*.zip')).join('\n')}"
    # remove_dir Rails.root.join("tmp/zip")
  end
end
