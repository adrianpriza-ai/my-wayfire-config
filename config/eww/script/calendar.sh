#!/bin/bash
YEAR=${2:-$(date +%Y)}
MONTH=${1:-$(date +%-m)}
MONTH_NAMES=(Januari Februari Maret April Mei Juni Juli Agustus September Oktober November Desember)
MONTH_NAME=${MONTH_NAMES[$((MONTH-1))]}
declare -A HOLIDAY_MAP
while read -r d; do
    [[ -n "$d" ]] && HOLIDAY_MAP["$d"]=1
done < <(
    curl -fsSL "https://api-hari-libur.vercel.app/api?year=$YEAR&month=$MONTH" 2>/dev/null \
    | jq -r '.data[]?.date // empty' 2>/dev/null
)
printf "<span size='large' weight='bold'>%s %s</span>\n\n" "$MONTH_NAME" "$YEAR"
echo "<span weight='bold'>Sen Sel Rab Kam Jum Sab Min</span>"
cal -m "$MONTH" "$YEAR" | tail -n +3 | while IFS= read -r line; do
    out=""
    for ((col=0; col<7; col++)); do
        day="${line:col*3:2}"
        day="${day// /}"
        if [[ -z $day ]]; then
            out+="    "
            continue
        fi
        printf -v DAY_NUM "%02d" "$day"
        printf -v DATE "%04d-%02d-%02d" "$YEAR" "$MONTH" "$DAY_NUM"
        color="#dddddd"
        [[ $col -eq 6 ]] && color="#ff6666"
        [[ ${HOLIDAY_MAP[$DATE]} ]] && color="#ff0000"
        printf -v formatted "%3s" "$day"
        out+="<span foreground='$color'>$formatted</span> "
    done
    echo "$out"
done
