require 'aws-sdk-s3'
require 'open-uri'

# Pobieramy plik z MediaFile[:url].
# Przesyłamy plik na S3.
# Zwracamy nowy URL pliku na S3.

module MediaUploader
  S3_BUCKET = 'your-bucket-name'
  AWS_REGION = 'your-region'

  def self.upload_from_url(media_file)
    file_url = media_file[:url]
    raise "Invalid URL" if file_url.nil? || file_url.empty?

    file_name = File.basename(URI.parse(file_url).path)

    temp_file = URI.open(file_url)

    s3 = Aws::S3::Resource.new(region: AWS_REGION)
    obj = s3.bucket(S3_BUCKET).object("media/#{file_name}")

    obj.put(body: temp_file, acl: 'public-read')

    obj.public_url
    
  rescue Error => e
    puts "Error in MediaUploader: #{e.message}"
    nil
  end
end