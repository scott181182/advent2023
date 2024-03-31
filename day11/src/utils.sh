#!/bin/bash

transpose() {
    lines=()
    while IFS= read -r line; do
        lines+=($line)
    done

    LENGTH=${#lines[0]}

    for ((i = 0; i < $LENGTH; i++)); do
        for line in ${lines[@]}; do
            echo -n ${line:$i:1}
        done
        echo ""
    done
}
expand_rows() {
    awk '{ if (/^\.+$/) { print $0; print $0; } else { print $0; } }'
}

get_coords() {
    line_index=0
    while IFS= read -r line; do
        for ((i = 0; i < ${#line}; i++)); do
            c=${line:$i:1}

            [[ $c == "#" ]] && echo "$line_index,$i"
        done
        line_index=$(( $line_index + 1 ))
    done
}

coord_distances() {
    coords=()
    while IFS= read -r line; do
        coords+=($line)
    done

    total_distance=0
    from_index=0
    for from in ${coords[@]}; do
        IFS=',' read -r -a from_coords <<< "$from"

        for to in ${coords[@]:from_index}; do
            [[ $from == $to ]] && continue;
            IFS=',' read -r -a to_coords <<< "$to"

            x_dist=$(( ${from_coords[0]} - ${to_coords[0]} ))
            y_dist=$(( ${from_coords[1]} - ${to_coords[1]} ))
            dist=$(( ${x_dist#-} + ${y_dist#-} ))
            total_distance=$(( $total_distance + $dist ))
        done

        from_index=$(( $from_index + 1 ))
    done

    echo $total_distance
}