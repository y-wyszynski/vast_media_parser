# VastProcessor Solution

This solution is designed to process VAST (Video Ad Serving Template) files, perform media file extraction, video transcoding, and upload the resulting files to Amazon S3. The solution is structured in a modular way to easily handle different stages of the process, from parsing VAST to generating a new VAST file with transcoded media files.

## Authors
- **@y-wyszynski**
- **@k-loza**

Please review the solution and provide any feedback or questions regarding the implementation.

## Program Workflow

The program begins execution in `root.rb`, where the `VastProcessor` module is invoked. Here's an overview of how the program works:

### Process Overview:
1. **VAST Parsing and MediaFile Extraction**
   - The program starts by parsing the VAST URL and extracting the media files.
   
2. **Download Media and Upload to S3**
   - Video files are downloaded and uploaded to S3.

3. **Transcoding**
   - The downloaded video files are transcoded to different formats.

4. **Upload Transcoded Files**
   - The transcoded media files are uploaded back to S3.

5. **Generate New VAST**
   - A new VAST file is created with the new transcoded media files.

6. **Upload New VAST**
   - The newly generated VAST file is uploaded to S3 and its URL is returned.

### Diagram (for flow)

![VAST_FLOW](https://github.com/user-attachments/assets/2592735e-22fe-439e-a960-a9f865c4ef81)
