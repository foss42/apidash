#!/bin/bash

# Remove the old merged file
rm -f coverage/lcov_combined.info

# First, add the root coverage
if [ -f "coverage/lcov.info" ]; then
    cat coverage/lcov.info > coverage/lcov_combined.info
fi

# Then, process each sub-package
for dir in packages/*; do
    if [ -f "$dir/coverage/lcov.info" ]; then
        # Use sed to prepend the package directory to the Source File (SF:) paths
        sed "s|SF:lib/|SF:$dir/lib/|g" "$dir/coverage/lcov.info" >> coverage/lcov_combined.info
    fi
done

# Generate the HTML
genhtml coverage/lcov_combined.info -o coverage/html
