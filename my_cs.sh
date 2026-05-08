#!/bin/bash
source "$(dirname $0)/coding-style.sh"

echo ""

if [[ ! -s "$EXPORT_FILE" ]]; then
    echo "No cs errors" | lolcat
    exit 0;
fi

FILE_PATTERN_TO_IGNORE=()

while IFS= read -r -d '' file; do
    #read each line from the .gitignore
    while IFS= read -r line || [[ -n "$line" ]]; do
        #skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        #append the $(dirname $file) so that the pattern applies to the same scope as the .gitignore it is in
        FILE_PATTERN_TO_IGNORE+=("$line")
    done < "$file"

done < <(find . -type f -iname '.gitignore' -print0)


FILES_TO_IGNORE=()

GREP_PATTERN=""


if (( ${#FILE_PATTERN_TO_IGNORE[@]} > 0 )); then

    #find every file/folder respecting the patterns to ignore
    for entry in "${FILE_PATTERN_TO_IGNORE[@]}"; do

        while IFS= read -r -d '' file; do
            #and add them to the list
            FILES_TO_IGNORE+=("$file")
        done < <(find . -iname "$entry" -print0)
    done

    #generating pattern for grep
    for i in "${!FILES_TO_IGNORE[@]}"; do
        if (( i > 0 )); then
            GREP_PATTERN+='\|'
        fi
        GREP_PATTERN+="${FILES_TO_IGNORE[$i]}"
    done

    LOGS=$(grep -v "$GREP_PATTERN" $EXPORT_FILE)
    IGNORED=$(grep -c "$GREP_PATTERN" $EXPORT_FILE)

    echo "Ignoring $IGNORED issues due to gitignores." #from the following files:"
    # for entry in "${FILE_PATTERN_TO_IGNORE[@]}"; do

    #     while IFS= read -r -d '' file; do
    #         echo "$file"
    #     done < <(find . -iname "$entry" -print0)
    # done
    # echo "use flag --all to print them anyway (not yet implemented :D)"

else
    echo "no files to ignore"
    LOGS=$(cat $EXPORT_FILE)
fi

if [ -z "$LOGS" ]; then
    echo "No cs errors" | lolcat
else
    echo "Errors:" | lolcat
    echo "$LOGS"
fi

