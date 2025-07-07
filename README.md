# Audio File Normalisation for Digital Asset Management

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15830991.svg)](https://doi.org/10.5281/zenodo.15830991)

This repository addresses a common challenge encountered within Digital Asset Management (DAM) systems: the ingestion of diverse audio file formats. This document outlines a robust methodology for normalising such assets into a unified and highly compatible `.mp4` container, ensuring seamless integration, consistent playback, and long-term preservation within a DAM environment.

## The Challenge: Diverse Audio Assets

A recent operational scenario involved a considerable collection of media files, encompassing a variety of audio formats such as `.mp3`, `.opus`, and `.m4a`. The objective was to integrate these valuable assets into our DAM system. However, the inherent preference of DAM systems for consistency and a standardised format presented a significant hurdle. Disparate formats often necessitate specific codecs, complicate metadata handling, and pose risks of obsolescence, thereby impeding efficient search, categorisation, and universal playback.

## The Solution: Standardisation to MP4

To mitigate these operational difficulties, a pre-ingestion normalisation strategy has been devised. This approach centres on converting all audio assets to a uniform `.mp4` container. It is important to note that while this provides a unified and broadly compatible format, it will not be a like-for-like replication of the original audio-only files. Instead, the `.mp4` container, incorporating a minimal visual track, serves as a pragmatic common denominator for simplicity and extensive compatibility within the DAM.

## Technical Implementation: Leveraging FFmpeg

By utilising FFmpeg and its companion tool, FFprobe (for media analysis), we can programmatically convert the audio collection into the desired `.mp4` format. The `.mp4` container, coupled with the H.264 video codec and AAC audio codec, represents a widely accepted standard suitable for web playback and integration with contemporary DAM systems.

## Batch Processing Script

![image](https://github.com/user-attachments/assets/781f37a0-1374-416a-ab60-9c04b7339b73)


The following Bash script facilitates this batch operation, automating the conversion process:

```bash
mkdir converted_videos # Ensure this directory exists before running the loop

for f in *.mp3 *.opus *.m4a; do
  if [ -f "$f" ]; then
    filename=$(basename "$f" | sed 's/\.[^.]*$//')
    
    # Get audio duration in seconds
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
    
    # Use the duration in the ffmpeg command
    ffmpeg -i "$f" -f lavfi -i "color=c=black:s=1920x1080:r=1" \
           -c:v libx264 -pix_fmt yuv420p -tune stillimage \
           -c:a aac -b:a 320k \
           -t "$duration" \
           "converted_videos/${filename}.mp4"
  fi
done
