# tfbs-classification

## Overview
In this project, I explored the transcription factor binding site (TFBS) classification task using linear SVM and LS-GKM models. I optimized workflows to two transcription factors: SP1 and CTCF. These TFs exhibit different binding activities, which is reflected in the different preprocessing steps the models required to discriminate between BS/background sequence, and the motif recoverability from the trained models. 

Some of the factors I experimented with:
* One-hot encoded sequences vs. k-mers as model input
* Dinucleotide shuffles of positive sequences vs. flanking sequences 1kb upstream/downstream from positive sequence window as negative samples
* 30bp vs. 200bp window lengths for input sequences
* SP1 vs. CTCF
* Linear SVM vs. LS-GKM

## Data 

## CTCF

## SP1

## Conclusions
“Because the linear SVM operates on unordered k-mer counts, it does not encode positional dependencies. Accordingly, direct reconstruction of a long positional motif produced diffuse, composition-like patterns. However, high-weight k-mers showed significant enrichment for similarity to the canonical CTCF motif compared to dinucleotide-matched random k-mers (p < 1e−4), indicating that the classifier learned biologically meaningful CTCF sequence preferences despite lacking explicit positional modeling.”
