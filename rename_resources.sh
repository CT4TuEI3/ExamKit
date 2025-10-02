#!/bin/bash

BASE_DIR="Sources/ExamKit/Resources"

rename_in_folder() {
    CATEGORY=$1  # A_B или C_D
    TYPE=$2      # tickets / topics / images
    EXT=$3       # json / jpg

    FOLDER="$BASE_DIR/questions/$CATEGORY/$TYPE"
    if [ "$TYPE" = "images" ]; then
        FOLDER="$BASE_DIR/images/$CATEGORY"
    fi

    echo "Processing $FOLDER ..."

    for FILE in "$FOLDER"/*.$EXT; do
        BASENAME=$(basename "$FILE")
        NEWNAME="${CATEGORY}_${BASENAME}"
        mv "$FILE" "$FOLDER/$NEWNAME"
        echo "Renamed: $BASENAME -> $NEWNAME"
    done
}

rename_in_folder "A_B" "tickets" "json"
rename_in_folder "C_D" "tickets" "json"

rename_in_folder "A_B" "topics" "json"
rename_in_folder "C_D" "topics" "json"

rename_in_folder "A_B" "images" "jpg"
rename_in_folder "C_D" "images" "jpg"
