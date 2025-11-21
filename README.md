[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/seqanalysis)

🌐 Overview
This repository contains two complementary MATLAB functions implementing Bross’ sequential analysis for paired binary outcomes and a Monte Carlo robustness evaluator for order-dependence:

• seqanalysis.m — performs sequential hypothesis testing based on the classical Bross decision map.
• seqanalysis_ordercheck.m — evaluates how sensitive the sequential conclusion is to the order of informative pairs.

The method is useful in clinical or experimental settings where pairs of subjects receive two treatments (A and B) and outcomes are binary (0/1). The sequential approach may stop early when sufficient evidence is accumulated.

⭐ Features
• Supports paired binary outcomes (A vs B)
• Automatically discards non-informative pairs
• Traverses the 31×31 Bross decision map
• Detects “A better”, “B better”, “No difference”, or “Twilight zone”
• Optional graphical visualization
• Robustness analysis via random permutations
• Binomial confidence intervals for stability of outcomes
• Optional waitbar for long Monte Carlo runs

🛠️ Installation
1. Clone the repository:
   git clone https://github.com/dnafinder/seqanalysis
2. Ensure seqanalysis.m, seqanalysis_ordercheck.m, and seqanmap.mat are on your MATLAB path.
No additional toolboxes are required except Statistics Toolbox for binofit.

▶️ Usage
Basic sequential analysis:
   out = seqanalysis(x);

Silent mode:
   out = seqanalysis(x, 0);

Robustness to ordering:
   stats = seqanalysis_ordercheck(x, 5000);

Disable progress bar:
   stats = seqanalysis_ordercheck(x, 5000, 0.05, false);

🔣 Inputs
seqanalysis:
   x      — N×2 matrix containing 0/1 outcomes.
   flag   — Show plot (1) or silent mode (0).

seqanalysis_ordercheck:
   x            — N×2 binary matrix.
   nperm        — Number of random permutations.
   alpha        — Significance level for confidence intervals.
   showProgress — Display waitbar (true/false).

📤 Outputs
seqanalysis returns:
   -1  Twilight (inconclusive)
    0  No difference
    1  A is better
    2  B is better
   NaN No informative pairs

seqanalysis_ordercheck returns a structure with:
   codes       — all permutation results
   freq        — table with counts, proportions, and confidence intervals
   pA, pB      — probability that A or B wins
   pNoDiff     — probability of no difference
   pTwilight   — probability of inconclusive results
   pNaN        — probability of no informative pairs

📘 Interpretation
• A high pA with narrow CI → robust evidence for A being better.
• A high pB → robust evidence for B being better.
• High pTwilight → order-dependent and inconclusive system.
• Mixed proportions → sequential analysis is very sensitive to ordering.

📝 Notes
The Bross decision map (seqanmap.mat) is included in this repository and must remain in the same folder as the functions. The sequential procedure assumes that the order of pairs is random; the robustness evaluator quantifies how strongly conclusions depend on that assumption.

📚 Citation
Cardillo G. (2008–2025). Sequential analysis and robustness evaluation.
GitHub: https://github.com/dnafinder/seqanalysis

👤 Author
Giuseppe Cardillo
Email: giuseppe.cardillo.75@gmail.com
GitHub: https://github.com/dnafinder

⚖️ License
This project is released under the GNU GPL-3.0 license.
