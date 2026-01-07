#!/bin/bash

CONDENSED_POS_PEAKS="ctcf_processed_data/condensed_peaks.bed"
OUTPUT_FILE="ctcf_processed_data/condensed_neg_peaks.bed"

awk -v offset=1000 -v W=50 '
BEGIN {OFS="\t"}

{
	chr = $1
	summit = $2 + $10

	# upstream
	s1 = summit - offset - (2*W)
	e1 = s1 + W
	if (s1 >= 0)
  		print chr, s1, e1

	# downstream
	s2 = summit + offset + W
	e2 = s2 + W
	print chr, s2, e2
}' "$CONDENSED_POS_PEAKS" > "$OUTPUT_FILE"
