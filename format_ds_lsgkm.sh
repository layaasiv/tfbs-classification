#!/bin/bash

INPUT_FILE="sp1_processed_data/pos_seqs.fa"
OUTPUT_FILE="sp1_ml_datasets/ls-gkm/train_pos_200bp.fa"

awk '
/^>/ {
  split(substr($0,2), a, ":")
  chr = a[1]
  flag = (chr ~ /^chr([0-9]|1[0-9])$/)
}
flag
' "$INPUT_FILE" > "$OUTPUT_FILE"
