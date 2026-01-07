#!/bin/bash

SEQS_FILE="./sp1_processed_data/pos_seqs.fa"
OUTPUT_FILE="./sp1_processed_data/pos_seqs_200bp.tsv"

awk '
BEGIN { OFS="\t" }

/^>/ {
	header = substr($0, 2)
	split(header, a, ":")
	chrom = a[1]

	split(a[2], b, "-")
	start = b[1]
	end = b[2]

	next
}

{
	sequence = $0
	label = 1
	print sequence, label, chrom, start, end
}
' "$SEQS_FILE" > "$OUTPUT_FILE"
