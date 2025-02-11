require_relative '../lib/vast_media_parser'
require_relative '../lib/media_uploader'
require_relative '../lib/vast_generator'
require_relative '../lib/vast_uploader'

# 1️⃣ Parsujemy VAST i pobieramy MediaFile.
# 2️⃣ Pobieramy pliki wideo i wysyłamy je na S3.
# 3️⃣ Transkodujemy pliki
# 4️⃣ Wysyłamy transkodowane pliki na S3
# 5️⃣ Tworzymy nowy VAST z transkodowanymi plikami
# 6️⃣ Zapisujemy nowy VAST na S3 i zwracamy jego url

module VastProcessor
  def self.process(vast_url)
    # Parsujemy VAST i pobieramy MediaFile
    media_files = VastParser.extract_media_files(vast_url)
    return nil if media_files.empty?

    # Pobieramy pliki wideo i wysyłamy je na S3
    new_media_urls = media_files.map do |media_file|
      uploaded_url = MediaUploader.upload_from_url(media_file)
      uploaded_url || (puts "Failed to upload #{media_file[:url]}"; nil)
    end.compact

    return nil if new_media_urls.empty?

    # Transkodowanie wszystkich plików**
    transcoded_files = new_media_urls.map { |url| MediaTranscoder.transcode(url) }

    # Wysyłamy transkodowane pliki na S3
    transcoded_s3_urls = transcoded_files.map do |file|
      MediaUploader.upload(file)
    end.compact
    return nil if transcoded_s3_urls.empty?

    # Tworzymy nowy VAST z wszystkimi nowymi plikami MediaFile
    new_vast = VastGenerator.generate_vast(vast_url, transcoded_s3_urls)
    return nil unless new_vast

    # Zapisujemy nowy VAST na S3
    VastUploader.upload_vast(new_vast)
    
    rescue Error => e
      puts "Error in VastProcessor: #{e.message}"
      nil
    end
  end
end

