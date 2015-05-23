require 'zip'
require 'csv'

namespace :csv do

  task :unzip, :dest_file do |t, args|
    args.with_defaults(:dest_file => Rails.root.join("tmp/zip/extracted"))

    Archive::FileZipper.new(Rails.root.join("tmp/zip/data.zip"), args[:dest_file]).zip!
    puts "Unzipping is completed..."
  end

  desc "import CSV rows to DB"
  task :import, [ :db_name, :dest_file ] => [:environment, :unzip] do |t, args|
    args.with_defaults(:dest_file => Rails.root.join("tmp/zip/extracted"))

    Dir.glob(args[:dest_file].join("**/*.txt")) do |filename|
      puts "Started importing from file: #{File.basename(filename)}..."

      db_name = (File.basename(filename) =~ /^r_c/i) ? 'track' : 'event' if args[:db_name].blank?
      date = File.basename(filename, ".txt").match(/.*_(\d{4})(\d{2})(\d{2})\z/) do 
        Date.new $1.to_i, $2.to_i, $3.to_i
      end
      FileUtils.chmod "a=wr", filename

      case db_name
      when 'track'
        fields =  %w(apple_id artist title label isrc vendor_id vendor_offer_code)
        CsvFile::Importer.new('tracks', filename, fields).import
      when 'event'
        fields =  %w(event_type end_reason_type event_start_time event_end_time customer_id apple_id device_type track_owner station_id storefront_name cma_flag heat_seeker_flag)
        CsvFile::Importer.new('events', filename, fields).import
        Event.update_all start_date: date
      else
        raise "No such #{args[:db_name]} exist..."
      end

      puts "Finished importing from file: #{File.basename(filename)}"
    end
  end

  desc "export CSV from DB"
  task :export, [ :start_date, :end_date, :labels ] => :environment do |t, args|
    storage_dir  = Storage::Directory.new(Rails.root.join("tmp"), 'report')
    storage_dir.create!
    storage_file = Storage::File.new(storage_dir.path_to_dir, 'data.csv')
    storage_file.create!
    storage_file.apply_permissions "a=wr"

    sql = Query::DailyReport.new(args).build_sql
    CsvFile::Exporter.new(sql, storage_file.path_to_file).export
  end
end
