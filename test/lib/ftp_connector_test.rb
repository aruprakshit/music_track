require 'test_helper'
require_relative "#{Dir.pwd}/lib/ftp_connector.rb"

class FTPConnectorTest < ActiveSupport::TestCase
  setup do
    # by default, match pattern is txt.gz and overwrite is false
    @download_to_path = "#{Rails.root}/tmp/imports/tests"

    # delete all the files under the directory we'll be uploading to
    Pathname.new(@download_to_path).children.each { |p| p.unlink }
    # we should not have any files now

    count = Dir.glob(@download_to_path+ "/**/*").select { |file| File.file?(file) }.count
    assert count == 0, "Test initialization failure; fix. Expected no files in directory after cleanup, got #{count} instead"
  end

  test 'the truth' do
    assert true
  end

  # for this to work, we need to have a sample
  # a path 201501 under the FTP root
  test 'downloading files from ftp should work' do
    # download the files to our directory
    FTPConnector.new.download_data("/srv/ftp/201501", @download_to_path, overwrite: true)

    # make sure we have downloaded some files
    count = Dir.glob(@download_to_path+ "/**/*").select { |file| File.file?(file) }.count
    assert count > 0, "No files have been downloaded"
  end

  test 'downloading files with overwrite should work' do
    # download the files to our directory
    FTPConnector.new.download_data("/srv/ftp/201501", @download_to_path, overwrite: true)

    # get the first file
    first_file_path = Dir.glob(@download_to_path + "/**/*").first
    modification_time = File.new(first_file_path).mtime

    # sleep for 1 second
    sleep(5)

    # download the files to our directory
    FTPConnector.new.download_data("/srv/ftp/201501", @download_to_path, overwrite: true)
    modification_time_2 = File.new(first_file_path).mtime
    assert modification_time != modification_time_2, "File has been overwritten"
  end
end

