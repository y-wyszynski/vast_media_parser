  # uruchomi pipeline i zwróci URL nowego VAST.
  field :wrapped_vast, types.String do
    description 'Wrap a VAST with our tracking and host media on S3'
    guard ->(_, _, ctx) { ::Creatives::ThirdPartyVastUrl.accessible?(ctx, :update) }
    argument :url, !types.String, 'VAST URL to wrap'
  
    resolve ->(_obj, args, _ctx) {
      vast_url = args[:url]
      raise "Invalid VAST URL" if vast_url.nil? || vast_url.empty?
  
      processed_vast = VastProcessor.process(vast_url)
      raise "Failed to process VAST" if processed_vast.nil?
  
      processed_vast
    }
  end