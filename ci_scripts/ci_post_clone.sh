#
//  ci_post_clone.sh
//  MacroProject
//
//  Created by Agfi on 09/10/24.
//

bash
#!/bin/bash
if ! command -v xcodegen &> /dev/null; then
    echo "XcodeGen not found. Installing..."
    brew install xcodegen
fi
ls .
# Change to the project directory
cd ..
# ALL STEPS AFTER CLONE PROJECT
# Generate the Xcode project using XcodeGen
echo "Generating Xcode project..."
xcodegen
echo "Check file on .xcodeproj"
ls *.xcodeproj
echo "Check file on project.xcworkspace"
echo "Check file on xcshareddata"
ls *.xcodeproj/project.xcworkspace/xcshareddata
# BASED ON MY EXPERIENCE xcshareddata DIRECTORY IS NOT EXIST, YOU NEED TO CREATE THE DIRECTORY
mkdir *.xcodeproj/project.xcworkspace/xcshareddata
# BASED ON MY EXPERIENCE swiftpm DIRECTORY IS NOT EXIST, YOU NEED TO CREATE THE DIRECTORY
mkdir *.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
fi