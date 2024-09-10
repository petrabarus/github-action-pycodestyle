#! /bin/bash

set -e

echo "::group::pycodestyle"
pycodestyle --version

echo "Getting list of changed files"

FILES=""
# If base is set, get the list of changed files
if [ -n "$INPUT_BASE" ]; then
  # get the list of changed files using curl instead of git
  URL="https://api.github.com/repos/$GITHUB_REPOSITORY/compare/$INPUT_BASE...$GITHUB_SHA"

  RESPONSE=$(curl -s \
    -H "Authorization: Bearer $INPUT_GITHUB_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    $URL)
  FILES=$(echo "$RESPONSE" | jq -r '.files[].filename')
else
  # otherwise, get the list of all files using find
  FILES=$(find . -type f)
fi

# Filter FILES by extension '.py'
FILES=$(echo "$FILES" | grep '\.py$')

# If INPUT_EXCLUDE is set, exclude the files
if [ -n "$INPUT_EXCLUDE" ]; then
    # Split INPUT_EXCLUDE by comma
    IFS=, read -ra PATTERN_EXCLUDE <<< "$INPUT_EXCLUDE"
    for PATTERN in "${PATTERN_EXCLUDE[@]}"; do
        FILES=$(echo "$FILES" | grep -v "$PATTERN")
    done
fi

pycodestyle $FILES | tee output.txt

# if output.txt is not empty, output failed
if [ -s output.txt ]; then
    RESULT="result=failed"
    # parse output.txt and send to github annotations
    # iterate line by line from output.txt
    while read -r line; do
        # parse colon in the lines
        file=$(echo "$line" | cut -d ':' -f 1)
        line_number=$(echo "$line" | cut -d ':' -f 2)
        column=$(echo "$line" | cut -d ':' -f 3)
        message=$(echo "$line" | cut -d ':' -f 4)
        # remove leading and trailing space in the message using sed
        message=$(echo "$message" | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')
        # get error code from message, split by space and get the first word
        error_code=$(echo "$message" | cut -d ' ' -f 1)

        # send to github annotations
        # echo "file: $file, line: $line_number, column: $column, message: $message, error_code: $error_code"
        echo "::error file=$file,line=$line_number::$message"
    done < output.txt
    EXIT_CODE=1
else
    RESULT="result=success"
    EXIT_CODE=0
fi

echo "$RESULT" >> $GITHUB_OUTPUT
echo "::endgroup::"
exit $EXIT_CODE