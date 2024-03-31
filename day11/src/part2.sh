#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/utils.sh"

get_blank_row_indices() {
    grep -nE '^\.+$' | cut -d: -f1 | awk '{ print $0 - 1 }'
}

EXPANSION_FACTOR=1000000

get_expanded_coords() {
    stdin=`cat`
    readarray -t expanded_rows <<< $(echo "$stdin" | get_blank_row_indices )
    readarray -t expanded_cols <<< $(echo "$stdin" | transpose | get_blank_row_indices )

    line_index=0
    while IFS= read -r line; do
        past_expanded_rows=$(printf -- '%s\n' "${expanded_rows[@]}" | awk "\$0 < $line_index { print \$0 }" | wc -l)
        for ((i = 0; i < ${#line}; i++)); do
            c=${line:$i:1}
            [[ $c != "#" ]] && continue

            past_expanded_cols=$(printf -- '%s\n' "${expanded_cols[@]}" | awk "\$0 < $i { print \$0 }" | wc -l)
            x_coord=$(( $i + $past_expanded_cols * ($EXPANSION_FACTOR - 1) ))
            y_coord=$(( $line_index + $past_expanded_rows * ($EXPANSION_FACTOR - 1) ))
            echo "$x_coord,$y_coord"
        done
        line_index=$(( $line_index + 1 ))
    done <<< "$stdin"
}

cat "$1" | get_expanded_coords | coord_distances