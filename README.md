# tfbs-classification

## Overview
In this project, I explored the transcription factor binding site (TFBS) classification task using SVM (linear kernel) and LS-GKM models. I optimized workflows to two transcription factors: SP1 and CTCF. These TFs exhibit different binding activities, which is reflected in the different preprocessing steps their respective models required to discriminate between BS/background sequence, and the motif recoverability of those models. 

Some of the factors I experimented with:
* One-hot encoded sequences vs. k-mers as model input
* Scaled vs. raw input
* Dinucleotide shuffles of positive sequences vs. flanking sequences 1kb upstream/downstream from positive sequence window as negative samples
* 30bp vs. 200bp window lengths for input sequences

## Data 
Using ChIP-seq narrowPeaks datasets from ENCODE database for SP1 (ENCFF769YSM) and CTCF (ENCFF144XRE). Datasets were condensed to 60 (SP1)/100 (CTCF) records per chromosome. Train/test splits were done by chromosome i.e., Train: chr1-chr19; Test: chr20-chr22,X,Y, to achieve ~80/20 split. This prevents information leakage between train and test, and ensures that the model generalizes well to unseen genomic regions. Input sequence windows were centered on the summit coordinates. 

## CTCF (CCCTC-Binding Factor)
CTCF is a ubiquitously expressed transcription factor that also acts as an insulator and regulates the 3D-organization of the genome. It's DNA binding site is composed of 11 zinc fingers, and it usually binds a long motif (~20bp) with a core consensus sequence of: RCCASNAGRKGGCRS. While CTCF is quite specific to its core motif, binding strength is also influenced by flanking sequences, co-factor binding and methylation status (prefers unmethylated CpG islands in its core consensus). Moreover, it also has lower affinity binding sites (harboring more variations from the consensus) that are cell type-specific. 

## SP1 (Specificity Protein 1)
SP1 is also universally expressed across many cell types. It has broad gene regulation activity, controlling the expression of proteins involved in various housekeeping processes such as cell cycle, DNA repair, apoptosis, etc. SP1 is composed of 3 zinc fingers which it uses to bind DNA at GC box motifs. It's consensus sequence is: (G/T)GGGCGG(G/A)(G/A)(C/T), with the core GGGCGG being the most important for high affinity binding. Notably, its binding motif is much shorter than that of CTCF, and it is relatively more degenerate. In fact, many *in vivo* SP1 binding sites deviate from this consensus, but still exhibit high affinity SP1 binding. Thus, SP1's DNA binding acitivty tolerates sequence variation within the GC box family of sequences.

## Findings
The SVM performs better with k-mer frequency as inputs than one-hot encoded sequences for both SP1 and CTCF. 
Dinucleotide shuffling of the positive sequences served as better negative samples i.e., the model was better able to find biologically meaningful patterns to discriminate between background and binding site. 
For SP1, performance improved significantly when trained on longer (200bp) sequences relative to shorter sequences (30bp); AUROC improved from 0.56 to 0.80. In contrast, shorter input sequences (50bp) were sufficient to achieve AUROC of 0.83. 

As a comparative benchmark, I also ran the same datasets through the LS-GKM model. This is a large-scale gapped k-mer SVM model used for regulatory DNA sequence classification tasks. This model achieves an AUROC of 0.88 for CTCF. Like the SVM, LS-GKM also struggled with 30bp inputs for SP1; it only achieves a AUROC of 0.55 on this data. With 200bp input sequences, it's AUROC improves to 0.89. 

To determine whether the model learned biologically meaningful patterns/motifs from the data, I recovered the most important k-mers from both models and aligned them with the consensus sequences from the ENCODE database using the PWM. The top 50 most important k-mers had significantly higher mean alignment score to the canonical CTCF motif compared to 10000 other randomly selected sets of 50 k-mers from the model (*p* < 1e-4 for both models). In contrast, the top 50 k-mers derived from the SP1 models did not show higher mean alignment to the canonical SP1 motif: *p* = 0.08 for linear SVM and *p* = 0.5 for LS-GKM. However, LS-GKM's top 50 k-mers did show enrichment for CpG-containing sequences relative to 10000 other randomly selected sets of 50 k-mers from the model (*p* = 2e-4). 

## Conclusions
In general, model performance is dependent on choice of background/negative samples, and for this task, k-mer frequency matrix is a better representation of the data than one-hot encoding the sequence. 

Predicting SP1 binding sites proves to be a more difficult task compared to predicting CTCF binding sites. The model's ability to discriminate between negative and positive samples for SP1 is improved by providing more context (larger sequence windows). Overall, LS-GKM outperforms the linear SVM in predicting SP1 and CTCF binding sequences from background.

Since the linear SVM operates on unordered k-mer counts, it does not encode positional dependencies. Accordingly, direct reconstruction of a long positional motif produced diffuse, composition-like patterns. However, high-weight k-mers showed significant enrichment for similarity to the canonical CTCF motif compared to dinucleotide-matched random k-mers (*p* < 1e−4), indicating that the classifier learned biologically meaningful CTCF sequence preferences despite lacking explicit positional modeling. 

While LS-DKM-derived k-mers for CTCF showed strong alignment to the canonical motif, SP1-associated k-mers did not align significantly to the JASPAR PWM. However, these k-mers were highly enriched for CpG-containing sequences relative to a random k-mer null (*p* = 2×10⁻⁴), consistent with SP1’s known preference for GC boxes and promoter-proximal CpG-rich contexts.
