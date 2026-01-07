#!/bin/bash

INPUT_FILE="sp1_processed_data/pos_seqs.fa"
OUTPUT_FILE="sp1_processed_data/neg_peaks_dinuc_200bp.fa"

awk '
/^>/ {
    if (seq) {
        print seq | "ushuffle -k 2 -s " seq
        close("ushuffle -k 2 -s " seq)
    }
    print
    seq=""
    next
}
{
    seq = seq $0
}
END {
    if (seq) {
        print seq | "ushuffle -k 2 -s " seq
        close("ushuffle -k 2 -s " seq)
    }
}
' "$INPUT_FILE" > "$OUTPUT_FILE"

