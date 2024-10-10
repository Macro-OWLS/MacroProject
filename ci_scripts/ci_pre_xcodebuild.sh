#!/bin/sh

#  ci_pre_xcodebuild.sh
#  MacroProject
#
#  Created by Ages on 10/10/24.
#  

#!/bin/bash

# Fail on any error
set -e

echo "Running post-clone script..."

# Install XcodeGen
if ! which xcodegen > /dev/null; then
  echo "XcodeGen not found. Installing..."
  brew install xcodegen
else
  echo "XcodeGen is already installed."
fi

# Generate the Xcode project using XcodeGen
echo "Generating Xcode project with XcodeGen..."
xcodegen generate

# Install Swift Package dependencies (like Supabase)
echo "Resolving Swift Package Manager dependencies..."
xcodebuild -resolvePackageDependencies

echo "Post-clone script completed."
