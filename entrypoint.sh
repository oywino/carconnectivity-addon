#!/bin/sh
set -e
echo ""
echo ""
echo ""
echo ">>>>>>>>> STARTING"
cd /tmp
tempio -conf /data/options.json -template carconnectivity.json.gtpl -out carconnectivity.json
if grep -q "debug" /data/options.json; then
    for file in versions.txt carconnectivity.json; do
        echo ">>>>>>>>> $(basename "$file")"
        cat "$file"
        echo "<<<<<<<<<<" 
    done
fi
/opt/venv/bin/carconnectivity-mqtt carconnectivity.json
echo ">>>>>>>>> STARTED"