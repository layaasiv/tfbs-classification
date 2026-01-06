# tfbs-classification

## Overview
In this project, I explored the transcription factor binding site (TFBS) classification task using linear SVM and LS-GKM models. I optimized workflows to two transcription factors: SP1 and CTCF. These TFs exhibit different binding activities, which is reflected in the different preprocessing steps their respective models required to discriminate between BS/background sequence, and the motif recoverability of those models. 

Some of the factors I experimented with:
* One-hot encoded sequences vs. k-mers as model input
* Dinucleotide shuffles of positive sequences vs. flanking sequences 1kb upstream/downstream from positive sequence window as negative samples
* 30bp vs. 200bp window lengths for input sequences

## Data 
Using ChIP-seq narrowPeaks datasets from ENCODE database for SP1 (ENCFF769YSM) and CTCF (ENCFF144XRE). Datasets were condensed to 60 (SP1)/100 (CTCF) records per chromosome. Train/test splits were done by chromosome i.e., Train: chr1-chr19; Test: chr20-chr22,X,Y, to achieve ~80/20 split. This prevents information leakage between train and test, and ensures that the model generalizes well to unseen genomic regions.   

## CTCF (CCCTC-Binding Factor)
CTCF is a ubiquitously expressed transcription factor that also acts as an insulator and regulates the 3D-organization of the genome. It's DNA binding site is composed of 11 zinc fingers, and it usually binds a long motif (~20bp) with a core consensus sequence of: RCCASNAGRKGGCRS. While CTCF is quite specific to its core motif, binding strength is also influenced by flanking sequences, co-factor binding and methylation status (prefers unmethylated CpG islands in its core consensus). Moreover, it also has lower affinity binding sites (harboring more variations from the consensus) that are cell type-specific. 

## SP1 (Specificity Protein 1)
SP1 is also universally expressed across many cell types. It has broad gene regulation activity, controlling the expression of proteins involved in various housekeeping processes such as cell cycle, DNA repair, apoptosis, etc. SP1 is composed of 3 zinc fingers which it uses to bind DNA at GC box motifs. It's consensus sequence is: (G/T)GGGCGG(G/A)(G/A)(C/T), with the core GGGCGG being the most important for high affinity binding. Notably, its binding motif is much shorter than that of CTCF, and it is relatively more degenerate. In fact, many *in vivo* SP1 binding sites deviate from this consensus, but still exhibit high affinity SP1 binding. Thus, SP1's DNA binding acitivty tolerates sequence variation within the GC box family of sequences.

## Conclusions
Since the linear SVM operates on unordered k-mer counts, it does not encode positional dependencies. Accordingly, direct reconstruction of a long positional motif produced diffuse, composition-like patterns. However, high-weight k-mers showed significant enrichment for similarity to the canonical CTCF motif compared to dinucleotide-matched random k-mers (p < 1e−4), indicating that the classifier learned biologically meaningful CTCF sequence preferences despite lacking explicit positional modeling.
