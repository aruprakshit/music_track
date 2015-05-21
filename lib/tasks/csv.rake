require 'zip'
require 'csv'

namespace :csv do

  task :unzip, :dest_file do |t, args|
    args.with_defaults(:dest_file => Rails.root.join("tmp/zip/extracted"))

    Zip::File.open(Rails.root.join("tmp/zip/data.zip")) do |zip_file|
      zip_file.each do |entry|
        puts "Unzipping the file: #{entry}"
        destination_dir = args[:dest_file].join(entry.name)
        mkdir_p destination_dir.dirname
        zip_file.extract(entry, destination_dir) { true }
      end
    end

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

      CSV.foreach(filename, col_sep: "\t", quote_char: "|", headers: true) do |line|
        case db_name
        when 'track'
          Track.create!(apple_id: line[0], artist: line[1], title: line[2],
                        label: line[3], isrc: line[4],
                        vendor_id: line[5], vendor_offer_code: line[6]
                       )
        when 'event'
          Event.create!(event_type: line[0], end_reason_type: line[1], customer_id: line[4],
                        device_type: line[6], track_owner: line[7], station_id: line[8],
                        storefront_name: line[9], cma_flag: line[10], heat_seeker_flag: line[11],
                        apple_id: line[5], start_date: date, event_start_time: line[2], event_end_time: line[3]
                       )
        else
          raise "No such #{args[:db_name]} exist..."
        end
        puts "#{line} is inserted into #{args[:db_name]} table..."
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
