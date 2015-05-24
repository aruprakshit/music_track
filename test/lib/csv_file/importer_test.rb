require 'test_helper'
require_relative "#{Dir.pwd}/lib/csv_file/importer.rb"
require_relative "#{Dir.pwd}/lib/csv_file/track_importer.rb"
require 'csv'

class ImporterTest < ActiveSupport::TestCase
  setup do
    @tracks_file_path = "#{Rails.root}/tmp/test/R_C_80028043_20150101.csv"
    @events_file_path = "#{Rails.root}/tmp/test/R_D_80028043_20150101.csv"
  end

  test 'importing tracks file into database should succeed' do
    Track.destroy_all
    CsvFile::TrackImporter.new.import! @tracks_file_path
    assert Track.count > 0
  end

  test 'importing events file into database should succeed' do
    Event.destroy_all
    CsvFile::EventImporter.new.import! @events_file_path
    assert Event.count > 0
  end

  test 'importing the same file twice should not crash' do
    Event.destroy_all
    CsvFile::EventImporter.new.import! @events_file_path
    event_count = Event.count
    CsvFile::EventImporter.new.import! @events_file_path
    assert Event.count == event_count, "Should not duplicate records in databse"
  end
end
