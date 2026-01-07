#!/bin/bash

BIGBED_FILE="raw_data/ENCFF144XRE.bigBed"
OUTPUT_FILE="ctcf_processed_data/condensed_peaks.bed"
LINES_PER_CHR=100

> "$OUTPUT_FILE"
declare -A counts

while IFS=$'\t' read -r chrom rest_of_line; do
	((counts[$chrom]++))
	if  ((counts[$chrom] <= LINES_PER_CHR)); then
		printf "%s\t%s\n" "$chrom" "$rest_of_line" >> "$OUTPUT_FILE"
	fi
done < <(bigBedToBed "$BIGBED_FILE" /dev/stdout)
