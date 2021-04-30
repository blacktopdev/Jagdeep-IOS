# author: ji@jiropole.net
#
# Set the version, build number (SCM revision) and build date in both the Info and Settings PLIST files.

echo "${TARGET_BUILD_DIR}"
BUILD_PLIST="${TARGET_BUILD_DIR}"/"${INFOPLIST_PATH}"
echo "Updating bundle PLIST at $BUILD_PLIST"

#BUILD_NUMBER=`git log --oneline | wc -l | tr -d '[[:space:]]'`
BUILD_NUMBER=`git rev-list --all|wc -l|xargs`
BUILD_DATE=$(date +'%Y-%m-%d')

/usr/libexec/PlistBuddy -c "Set :CFBuildDate $BUILD_DATE" $BUILD_PLIST
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" $BUILD_PLIST

BUNDLE_VERSION_SHORT=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $BUILD_PLIST)

# Update the Settings.bundle
BUILD_INFO="$BUNDLE_VERSION_SHORT #${BUILD_NUMBER} ${BUILD_DATE}"
/usr/libexec/PlistBuddy "${TARGET_BUILD_DIR}"/"${PRODUCT_NAME}.app"/Settings.bundle/Root.plist -c "set PreferenceSpecifiers:1:DefaultValue $BUILD_INFO"

echo "updated ${TARGET_BUILD_DIR}"/"${PRODUCT_NAME}.app"/Settings.bundle/Root.plist
echo "BUILD_INFO: ${BUILD_INFO}"
