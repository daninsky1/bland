#!/bin/bash
# 'Apache' is default checked, 'MySQL' is default unchecked
whiptail --title "Set Default" --checklist "Choose" 10 40 2 \
--default-item "Item2" \
"Item1" "Description" OFF \
"Item2" "Description" OFF


echo "Selected: $OPTION"