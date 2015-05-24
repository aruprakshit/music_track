module CsvFile
  class TrackImporter < Importer
    def self.fields
      %w(apple_id artist title label isrc vendor_id vendor_offer_code)
    end

    def self.model
      return Track
    end
  end
end
