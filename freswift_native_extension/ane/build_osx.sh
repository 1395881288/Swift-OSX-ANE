#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"
echo $pathtome

PROJECT_NAME=SwiftOSXANE
FRESWIFT_NAME=FreSwift

AIR_SDK="/Users/User/sdks/AIR/AIRSDK_26"
echo $AIR_SDK

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi
if [ ! -d "$pathtome/platforms/mac" ]; then
mkdir "$pathtome/platforms/mac"
mkdir "$pathtome/platforms/mac/release"
mkdir "$pathtome/platforms/mac/debug"
fi

if [ ! -d "$pathtome/platforms/default" ]; then
mkdir "$pathtome/platforms/default"
fi

#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/CommonDependencies.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/CommonDependencies.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/mac/release"
cp "$pathtome/library.swf" "$pathtome/platforms/mac/debug"
cp "$pathtome/library.swf" "$pathtome/platforms/default"

#Copy native libraries into place.
echo "Copying native libraries into place."

cp -R -L "$pathtome/../../native_library/mac/$PROJECT_NAME/$FRESWIFT_NAME/$FRESWIFT_NAME-Swift.h" "$pathtome/../../native_library/mac/$PROJECT_NAME/Build/Products/Release/$FRESWIFT_NAME.framework/Versions/A/Headers/$FRESWIFT_NAME-Swift.h"
cp -R -L "$pathtome/../../native_library/mac/$PROJECT_NAME/$FRESWIFT_NAME/$FRESWIFT_NAME-Swift.h" "$pathtome/../../native_library/mac/$PROJECT_NAME/Build/Products/Debug/$FRESWIFT_NAME.framework/Versions/A/Headers/$FRESWIFT_NAME-Swift.h"

cp -R -L "$pathtome/../../native_library/mac/$PROJECT_NAME/Build/Products/Release/$FRESWIFT_NAME.framework" "$pathtome/platforms/mac/release"
cp -R -L "$pathtome/../../native_library/mac/$PROJECT_NAME/Build/Products/Debug/$FRESWIFT_NAME.framework" "$pathtome/platforms/mac/debug"


mv "$pathtome/platforms/mac/debug/$FRESWIFT_NAME.framework/Versions/A/Frameworks" "$pathtome/platforms/mac/debug/$FRESWIFT_NAME.framework"
mv "$pathtome/platforms/mac/release/$FRESWIFT_NAME.framework/Versions/A/Frameworks" "$pathtome/platforms/mac/release/$FRESWIFT_NAME.framework"

rm -r "$pathtome/platforms/mac/debug/$FRESWIFT_NAME.framework/Versions"
rm -r "$pathtome/platforms/mac/release/$FRESWIFT_NAME.framework/Versions"

#Run the build command.
echo "Building Release."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/CommonDependencies.ane" "$pathtome/extension_osx.xml" \
-swc "$pathtome/CommonDependencies.swc" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/release" "$FRESWIFT_NAME.framework" "library.swf" \
-platform default -C "$pathtome/platforms/default" "library.swf"


echo "Building Debug."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/CommonDependencies-debug.ane" "$pathtome/extension_osx.xml" \
-swc "$pathtome/CommonDependencies.swc" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/debug" "$FRESWIFT_NAME.framework" "library.swf" \
-platform default -C "$pathtome/platforms/default" "library.swf"

if [[ -d "$pathtome/debug" ]]
then
rm -r "$pathtome/debug"
fi

mkdir "$pathtome/debug"
unzip "$pathtome/CommonDependencies-debug.ane" -d  "$pathtome/debug/CommonDependencies.ane/"


rm -r "$pathtome/platforms/mac"
rm -r "$pathtome/platforms/default"
rm "$pathtome/CommonDependencies.swc"
rm "$pathtome/library.swf"
rm "$pathtome/CommonDependencies-debug.ane"

