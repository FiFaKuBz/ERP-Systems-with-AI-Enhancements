#!/bin/bash
SOURCE=$1
NAME="${SOURCE%.*}"
BUILD_DIR="./build"

# Auto-detect Noto Thai font path
THAI_FONT=$(fc-list | grep -i "noto" | grep -i "thai" | grep -i "regular" | head -1 | cut -d: -f1 | xargs)
echo "Using font: $THAI_FONT"

mkdir -p "$BUILD_DIR"

jupyter nbconvert --to latex "$NAME.ipynb" --no-input --output-dir="$BUILD_DIR"
sed -i 's/\\documentclass\[11pt\]{article}/\\documentclass[9pt]{extarticle}\n\\usepackage[margin=1.5cm]{geometry}/' "$BUILD_DIR/$NAME.tex"
sed -i "s|\\\\usepackage\[T1\]{fontenc}|\\\\usepackage{fontspec}\n\\\\XeTeXlinebreaklocale \"th\"\n\\\\setmainfont{$THAI_FONT}|" "$BUILD_DIR/$NAME.tex"

xelatex -output-directory="$BUILD_DIR" "$BUILD_DIR/$NAME.tex" && \
xelatex -output-directory="$BUILD_DIR" "$BUILD_DIR/$NAME.tex" && \
mv "$BUILD_DIR/$NAME.pdf" "./$NAME.pdf" && \
rm -rf "$BUILD_DIR"

echo "Done! PDF saved as $NAME.pdf"