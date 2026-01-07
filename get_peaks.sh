#!/bin/bash

BED_FILE="./ctcf_processed_data/condensed_peaks.bed"
OUTPUT_FILE="./ctcf_processed_data/condensed_pos_windows.bed"


awk -v W=50 '
BEGIN {OFS="\t"}
{
	summit = $2 + $10
	half = int(W/2)
	start = summit - half
	end = summit + half
	if (start >= 0)
		print $1, start, end
}
' "$BED_FILE" > "$OUTPUT_FILE"
