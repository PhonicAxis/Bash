#!/bin/sh
cupsctl --no-share-printers
lpadmin -p ALL -o printer-is-shared="False"
exit 0