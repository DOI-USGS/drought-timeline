#!/bin/bash

# This cuts a tall PNG into stacked slices for faster loading on websites
# intended for use with lazy loading to optimize website performance
#
# HOW TO USE:
# 1. Make sure ImageMagick is installed (`brew install imagemagick` on macOS)
# 2. Put this script in the same folder as your large PNG image
# 3. Set the input image name and max slice height below
# 4. To run the script, run these lines in terminal:
#      chmod +x split-image.sh  # only once to make it executable
#      ./split_image.sh # runs the script
#
# The original image will remain unchanged
# -----------------------------

# set input image and max slice height
INPUT="src/assets/images/duration-chart/swarm_jd7d_2pct_compressed_vertical.png"  # image filename
MAX_HEIGHT=1600 # max height in pixels per slice - 1200px is a good default for most size, or 1600 for high res screens
OUTDIR="src/assets/images/duration-chart/slices" # output folder

# delete all files in the output directory if it exists
if [ -d "$OUTDIR" ]; then
  rm -rf "$OUTDIR"/*
fi

# create output directory if it doesn't exist
mkdir -p $OUTDIR

# get image dimensions using ImageMagick's identify
read IMG_WIDTH IMG_HEIGHT <<< $(identify -format "%w %h" "$INPUT")

# calculate number of vertical slices
NUM_ROWS=$(( (IMG_HEIGHT + MAX_HEIGHT - 1) / MAX_HEIGHT ))

# print summary
echo "Image size: ${IMG_WIDTH}x${IMG_HEIGHT}px"
echo "Splitting into $NUM_ROWS row(s) of max $MAX_HEIGHTpx height"

# crop the image
magick "$INPUT" -crop "${IMG_WIDTH}x${MAX_HEIGHT}" +repage "$OUTDIR/part_%02d.png"

echo "✅ Done! Slices saved in: $OUTDIR"
