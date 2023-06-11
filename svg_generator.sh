#!/bin/bash

read -p "Enter a single letter: " letter

# Check if the letter entered is a single character
if [[ ${#letter} -ne 1 ]]; then
  echo "Please enter a single letter."
  exit 1
fi

# Create a temporary folder to store SVGs
temp_folder=$(mktemp -d)

# Generate the SVG files
sizes=("48x48" "72x72" "96x96" "144x144" "192x192" "256x256" "384x384" "512x512")

for size in "${sizes[@]}"; do
  # Extract the width and height values from the size
  IFS='x' read -r width height <<< "$size"

  # Calculate the circle's center coordinates and radius
  cx=$((width/2))
  cy=$((height/2))
  r=$((width/4))

  # Calculate the font size based on the circle's radius
  font_size=$((r*12/13))

  # Create the SVG content
  svg_content="<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"$width\" height=\"$height\"><circle cx=\"$cx\" cy=\"$cy\" r=\"$r\" fill=\"#000\"/><text x=\"$cx\" y=\"$cy\" font-family=\"Arial\" font-size=\"$font_size\" fill=\"#FFF\" font-weight=\"bold\" text-anchor=\"middle\" dominant-baseline=\"middle\">$letter</text></svg>"

  # Save the SVG file
  svg_file="$temp_folder/icon_$size.svg"
  echo "$svg_content" > "$svg_file"
done

# Move the SVG files to the desired folder
destination_folder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mv "$temp_folder"/*.svg "$destination_folder"

echo "SVG files generated successfully in $destination_folder"
