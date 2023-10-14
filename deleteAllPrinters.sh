#!/bin/bash
# Get a list of installed printers and deletes them
lpstat -p | awk '{print $2}' | while read printer
do
echo "Deleting Printer:" $printer
lpadmin -x $printer
done