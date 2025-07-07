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
