[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/seqanalysis)

🌐 Overview
This repository contains two complementary MATLAB functions implementing Bross’ sequential analysis for paired binary outcomes and a Monte Carlo robustness evaluator for order-dependence:

• seqanalysis.m — performs sequential hypothesis testing based on the classical Bross decision map.  
• seqanalysis_ordercheck.m — evaluates how sensitive the sequential conclusion is to the order of informative pairs.

This methodology is used in clinical or experimental paired designs where subjects receive two treatments (A and B) with binary (0/1) responses. Sequential analysis allows early stopping when evidence accumulates sufficiently.

⭐ Features
• Sequential analysis for paired binary outcomes  
• Automatic removal of non-informative pairs  
• Traversal of the 31×31 Bross decision matrix  
• Detection of “A better”, “B better”, “No difference”, “Twilight zone”  
• Optional graphical visualization  
• Random-permutation robustness evaluation  
• Binomial confidence intervals  
• Optional progress bar for long Monte Carlo simulations  

🛠️ Installation
1. Clone the repository:  
   git clone https://github.com/dnafinder/seqanalysis  
2. Ensure seqanalysis.m, seqanalysis_ordercheck.m, and seqanmap.mat remain in the same folder.  

▶️ Usage
Sequential analysis:
   out = seqanalysis(x);

Robustness estimator:
   stats = seqanalysis_ordercheck(x, 5000);

Disable progress bar:
   stats = seqanalysis_ordercheck(x, 5000, 0.05, false);

Example dataset:
   x = [1 1; 1 0; 0 0; 1 0; 1 0; 1 1; 0 1; 1 1; 1 0; 1 0; ...
        1 0; 1 1; 1 0; 0 1; 0 0; 1 0; 1 0; 1 0; 1 1; 1 0];

   out   = seqanalysis(x);  
   stats = seqanalysis_ordercheck(x, 5000);

🔣 Inputs
seqanalysis:
   x      — N×2 binary matrix  
   flag   — show plot (1) or silent mode (0)  

seqanalysis_ordercheck:
   x            — N×2 binary matrix  
   nperm        — number of permutations  
   alpha        — CI level  
   showProgress — show waitbar (true/false)  

📤 Outputs
seqanalysis returns:
   -1  Twilight (inconclusive)  
    0  No difference  
    1  A is better  
    2  B is better  
   NaN No informative pairs  

Example output figure (seqanalysis.jpg included in repository):
![](https://github.com/dnafinder/seqanalysis/blob/master/seqanalysis.jpg)

seqanalysis_ordercheck returns:
   codes       — all results from permutations  
   freq        — table with counts, proportions, and confidence intervals  
   pA, pB      — probability A or B is better  
   pNoDiff     — probability of no difference  
   pTwilight   — probability of twilight zone  
   pNaN        — probability of no informative pairs  

📘 Interpretation
• High pA or pB indicates robust directional evidence.  
• High pTwilight suggests sensitivity or insufficient information.  
• Mixed outcomes indicate order-dependence.  
• seqanalysis.jpg provides a visual explanation of the sequential path.  

📝 Notes
seqanmap.mat contains the Bross decision matrix and must be loaded by seqanalysis.m.  
The robustness evaluator quantifies how stable the conclusion is against random reorderings.  

📚 Citation
Cardillo G. (2008–2025). Sequential analysis and robustness evaluation.  
GitHub: https://github.com/dnafinder/seqanalysis  

👤 Author
Giuseppe Cardillo  
Email: giuseppe.cardillo.75@gmail.com  
GitHub: https://github.com/dnafinder  

⚖️ License
This project is released under the GNU GPL-3.0 license.
