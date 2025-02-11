require 'aws-sdk-s3'

module VastUploader
    S3_BUCKET = 'your-bucket-name'
    AWS_REGION = 'your-region'
  
    def self.upload_vast(vast_xml)
      raise "Invalid VAST XML" if vast_xml.nil? || vast_xml.empty?
      file_name = "wrapped_vast_#{Time.now.to_i}.xml"
  
     
      begin
        s3 = Aws::S3::Resource.new(region: AWS_REGION)
        obj = s3.bucket(S3_BUCKET).object("vast/#{file_name}")

        obj.put(body: vast_xml, acl: 'public-read')

        obj.public_url
        
      rescue Error => e
        puts "Error in VastUploader: #{e.message}"
        nil
      end
    end
  end
  