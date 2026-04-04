#!/bin/bash

TITLE=$(playerctl metadata title 2>/dev/null)
case "$TITLE" in
    'Franz Ferdinand - This Fire (Video)')
        echo "/home/momoi/.config/eww/walls/fffire-bg.jpg"
        ;;
    'GODDESS OF VICTORY: NIKKE | NYA NYA PARADISE Event Story BGM 「Lovely Lonely Cat」' | 'Lovely Lonely Cat [GODDESS OF VICTORY: NIKKE OST]')
        echo "/home/momoi/.config/eww/walls/cda.jpg"
        ;;
    '【 Arknights 】 Misty Memory (Night Version) Unofficial Music Video ft. Nian Bean')
        echo "/home/momoi/.config/eww/walls/artwork.php.jpg"
        ;;
    'Tiny Little Adiantum')
        echo "/home/momoi/.config/eww/walls/image.png"
        ;;
	'')
        echo ""
        ;;
esac
