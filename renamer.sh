#!/bin/bash
# Bulk file renamer with a dry-run mode

dry=false
mode=""
prefix=""

usage() {
    echo "Usage: bash renamer.sh -m <lower|upper|spaces|prefix|number> [-p text] [-d] <folder>"
    echo " -m rename mode"
    echo " -p text to add in prefix mode"
    echo " -d dry run (preview only, changes nothing)"
    exit 1
}

while getopts "m:p:d" opt; do 
    case "$opt" in
        m) mode="$OPTARG" ;;
        p) prefix="$OPTARG" ;;
        d) dry=true ;;
        *) usage ;; 
    esac
done
shift $((OPTIND - 1))

folder="${1:-.}"

[ -z "$mode" ] && usage
[ -d "$folder" ] || { echo "Error: '$folder' is not a folder"; exit 1; }

if [ "$mode" = "prefix" ] && [ -z "$prefix" ]; then
    echo "Error: prefix mode needs -p text"
    exit 1
fi 

count=0
n=1

for path in "$folder"/*; do 
    [ -f "$path" ] || continue

    old=$(basename "$path")
    [ "$old" = "renamer.sh" ] && continue

    case "$mode" in 
        lower)  new="${old,,}" ;;
        upper)  new="${old^^}" ;;
        spaces) new="${old// /_}" ;;
        prefix) new="${prefix}${old}" ;;
        number)
            ext=""
            [[ "$old" == *.* ]] && ext=".${old##*.}"
            new=$(printf "%03d%s" "$n" "$ext")
            n=$((n + 1))
            ;;
        *) echo "Error: unknown mode '$mode'"; usage ;;
    esac

    [ "$old" = "$new" ] && continue

    if [ -e "$folder/$new" ] && [ "${old,,}" != "${new,,}" ]; then 
        echo "Skipped $old -> $new"
    else 
        tmp="$folder/.renaming.$$"
        mv "$path" "$tmp" && mv "$tmp" "$folder/$new"
        echo "Renamed $old -> $new"
    fi 
    count=$((count + 1))
done 

verb="renamed"
[ "$dry" = true ] && verb="would be renamed"
echo "Done. $count file(s) $verb."
