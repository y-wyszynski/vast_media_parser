require 'nokogiri'
require 'open-uri'

# Pobieramy XML VAST.
# Parsujemy MediaFile.
# Zwracamy listę znalezionych plików wideo.

module VastParser
  def self.extract_media_files(vast_url)
    raise "Invalid VAST XML" if doc.at('VAST').nil?

    begin
      vast_xml = URI.open(vast_url).read
    rescue Error => e
      raise "Failed to fetch VAST XML: #{e.message}"
    end    

    doc = Nokogiri::XML(vast_xml)
    raise "Invalid VAST XML" if doc.at('VAST').nil?
  
    media_files = []
    doc.xpath('//MediaFiles/MediaFile').each do |media_file|
      media_files << {
        id: media_file['id'],
        delivery: media_file['delivery'],
        type: media_file['type'],
        width: media_file['width'],
        height: media_file['height'],
        bitrate: media_file['bitrate'],
        url: media_file.content.strip
      }
    end

    media_files
    
  rescue Error => e
    puts "Error in VastParser: #{e.message}"
    []
  end
  end
end