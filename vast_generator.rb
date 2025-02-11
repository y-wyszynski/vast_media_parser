require 'nokogiri'

# Modyfikujemy MediaFile w wrapperze, zastępując URL nowym z S3.
# Generujemy nowy XML VAST.

module VastGenerator
    def self.generate_vast(vast_url, new_media_urls)
      # Parsujemy oryginalny VAST
      vast_doc = Nokogiri::XML(URI.open(vast_url))
  
      raise "Invalid VAST XML" if vast_doc.at('VAST').nil?

      existing_media_files = vast_doc.xpath('//MediaFiles')
      existing_media_files.remove if existing_media_files

      # tworzymy nową sekcję <MediaFiles>
      media_files_element = Nokogiri::XML::Node.new('MediaFiles', vast_doc)
      
      new_media_urls.each do |new_url|
        media_file_element = Nokogiri::XML::Node.new('MediaFile', vast_doc)
        media_file_element['delivery'] = 'progressive'
        media_file_element['type'] = 'video/mp4'
        media_file_element.content = new_url # URL do nowego pliku wideo
  
        media_files_element.add_child(media_file_element)
      end

      # vast_doc.root.add_child(media_files_element)
      # nową sekcję do VAST
      vast_doc.at('//MediaFiles').add_child(media_files_element)
  
      # Zwracamy nowy plik VAST
      vast_doc.to_xml
      
      rescue Error => e
        puts "Error in VastGenerator: #{e.message}"
        nil
      end
    end
  end

  require 'nokogiri'

  
