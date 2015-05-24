module CsvFile
  class EventImporter < Importer
    def self.fields
      %w(event_type end_reason_type event_start_time event_end_time customer_id
                 apple_id device_type track_owner station_id storefront_name cma_flag
               heat_seeker_flag)
    end

    def self.model
      return Event
    end
  end
end
