require 'open3'

# Transkodowanie plików wideo na różne formaty i jakość.
# Obsługiwane formaty: MP4, WebM, HLS.
# Generuje kilka wersji jakościowych.
module MediaTranscoder
  OUTPUT_FORMATS = {
    mp4: 'libx264',
    webm: 'libvpx-vp9',
    hls: 'hls'  # HLS wymaga segmentacji
  }.freeze

  QUALITY_PRESETS = {
    high: '1920x1080',
    medium: '1280x720',
    low: '854x480'
  }.freeze

  def self.transcode(input_path)
    transcoded_files = {}

    OUTPUT_FORMATS.each do |format, codec|
      QUALITY_PRESETS.each do |quality, resolution|
        output_path = generate_output_path(input_path, format, quality)
        command = build_ffmpeg_command(input_path, output_path, codec, resolution, format)

        execute_transcoding(command)
        transcoded_files[[format, quality]] = output_path
      end
    end

    transcoded_files
  end

  def self.generate_output_path(input_path, format, quality)
    base_name = File.basename(input_path, '.*')
    directory = File.dirname(input_path)
    File.join(directory, "#{base_name}_#{quality}.#{format}")
  end

  def self.build_ffmpeg_command(input_path, output_path, codec, resolution, format)
    case format
    when :hls
      "ffmpeg -i #{input_path} -c:v #{codec} -s #{resolution} -hls_time 10 -hls_list_size 0 -f hls #{output_path}"
    else
      "ffmpeg -i #{input_path} -c:v #{codec} -s #{resolution} #{output_path}"
    end
  end

  def self.execute_transcoding(command)
    stdout, stderr, status = Open3.capture3(command)
    unless status.success?
      raise "FFmpeg error: #{stderr}"
    end
  end
end
