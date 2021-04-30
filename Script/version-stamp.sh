# author: ji@jiropole.net
#
# Set the x.x.x version number specified in the command argument

FULL_VERSION="$1"

# get a string containing all plists in the Application root
PLIST_STRING=$(find "SOLTEC" -name "Info*.plist" -maxdepth 2)

while IFS=';' read -ra PLIST_FILES; do
      for BUILD_PLIST in "${PLIST_FILES[@]}"; do
      	echo "Processing PLIST file $BUILD_PLIST"

		/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $FULL_VERSION" $BUILD_PLIST

	done
done <<< "$PLIST_STRING"
