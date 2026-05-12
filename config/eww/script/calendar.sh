#!/bin/bash
YEAR=${2:-$(date +%Y)}
MONTH=${1:-$(date +%-m)}
MONTH_NAME=$(date -d "$YEAR-$MONTH-01" +%B | sed '
s/January/Januari/; s/February/Februari/; s/March/Maret/;
s/April/April/; s/May/Mei/; s/June/Juni/;
s/July/Juli/; s/August/Agustus/; s/September/September/;
s/October/Oktober/; s/November/November/; s/December/Desember/')

DATA=$(curl -s "https://libur.deno.dev/api?year=$YEAR&month=$MONTH")
HOLIDAYS=$(echo "$DATA" | jq -r '.[].date')

echo "<span size='large' weight='bold'>$MONTH_NAME $YEAR</span>"
echo ""
echo "<span weight='bold'>Sen Sel Rab Kam Jum Sab Min</span>"

cal -m $MONTH $YEAR | tail -n +3 | while IFS= read -r line; do
    out=""
    for (( col=0; col<7; col++ )); do
        day="${line:$((col * 3)):2}"
        day=$(echo "$day" | tr -d ' ')
        if [ -z "$day" ]; then
            out="$out    "
            continue
        fi
        DAY_NUM=$(printf "%02d" "$day")
        DATE="$YEAR-$(printf "%02d" "$MONTH")-$DAY_NUM"
        color="#dddddd"
        if [ $col -eq 6 ]; then color="#ff6666"; fi
        if echo "$HOLIDAYS" | grep -q "$DATE"; then color="#ff0000"; fi
        out="$out<span foreground='$color'>$(printf "%3s" "$day")</span> "
    done
    echo "$out"
done
