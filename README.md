# Transcription Factor Binding Site Classification

Binary classification of transcription factor binding sites (TFBS) using k-mer SVM and LS-GKM models, with motif interpretability analysis. Applied to two transcription factors with distinct binding properties: CTCF and SP1.

## Tools & Technologies
- **Models:** Linear k-mer SVM, LS-GKM (gapped k-mer SVM)
- **Libraries:** scikit-learn, NumPy, pandas, Matplotlib
- **Data:** ENCODE ChIP-seq narrowPeak datasets
- **Scripts:** Bash workflows for data preprocessing and model execution

## Project Overview
This project explores sequence-based classification of transcription factor binding sites and evaluates whether learned sequence features correspond to known biological motifs. Two TFs with distinct binding characteristics were used as a comparative benchmark:

- **CTCF** — binds a long, highly specific ~20bp motif; key regulator of genome 3D organization
- **SP1** — binds short, degenerate GC-box motifs; broad gene regulatory activity

Key design decisions investigated: input representation (one-hot vs k-mer frequency), negative sample strategy (dinucleotide shuffles vs flanking sequences), and sequence window length.

## Data
ChIP-seq narrowPeak datasets from ENCODE:
- SP1: ENCFF769YSM
- CTCF: ENCFF144XRE

Train/test splits were performed by chromosome (Train: chr1–chr19; Test: chr20–chr22, X, Y) to prevent data leakage and ensure generalization to unseen genomic regions.

## Results

### Model Performance (AUROC)
| Model | TF | Window | AUROC |
|---|---|---|---|
| Linear SVM | SP1 | 30bp | 0.56 |
| Linear SVM | SP1 | 200bp | 0.80 |
| Linear SVM | CTCF | 50bp | 0.83 |
| LS-GKM | SP1 | 30bp | 0.55 |
| LS-GKM | SP1 | 200bp | 0.89 |
| LS-GKM | CTCF | 50bp | 0.88 |

### Motif Interpretability
| Model | TF | Result |
|---|---|---|
| Linear SVM | CTCF | Top 50 k-mers significantly enriched for canonical motif vs random (p < 1e-4) |
| LS-GKM | CTCF | Top 50 k-mers significantly enriched for canonical motif vs random (p < 1e-4) |
| Linear SVM | SP1 | No significant PWM alignment (p = 0.08) |
| LS-GKM | SP1 | No PWM alignment (p = 0.5), but significant CpG enrichment (p = 2e-4) |

## Key Findings
- k-mer frequency outperforms one-hot encoding as input representation for both TFs
- Dinucleotide-shuffled negatives yield better model discrimination than flanking sequences
- SP1 requires longer sequence windows (200bp) due to its degenerate binding motif; CTCF performs well at 50bp
- LS-GKM consistently outperforms linear SVM across conditions
- CTCF motif is recoverable from both models despite lack of explicit positional modeling, consistent with its strong, specific consensus sequence
- SP1 k-mers reflect GC-box composition rather than a positional motif, consistent with its known binding degeneracy

## Conclusions
Model performance is strongly influenced by negative sample choice and input representation. SP1 binding site prediction is inherently more difficult than CTCF due to its degenerate GC-box motif and tolerance for sequence variation. Interpretability analysis reveals TF-specific differences in what the model learns: positional motif recovery for CTCF vs compositional enrichment for SP1.

## Setup
```bash
pip install scikit-learn numpy pandas matplotlib
```
LS-GKM requires a separate installation — see the [LS-GKM GitHub](https://github.com/Dongwon-Lee/lsgkm). Bash scripts for data preprocessing are in the `bash_scripts/` directory.
