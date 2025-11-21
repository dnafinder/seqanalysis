[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/seqanalysis)

🌐 Overview
seqanalysis implements a sequential analysis procedure for paired binary outcomes from two treatments (A and B), following Bross’ sequential medical plans. Each pair of patients receives A and B, and their responses are coded as 1 (positive) or 0 (negative). Non-informative pairs (both positive or both negative) are discarded, and the remaining pairs are used to walk through a pre-defined 31x31 decision map. The walk stops when a decision boundary is reached or when the data are exhausted.

⭐ Features
- Sequential decision procedure for paired binary data (A vs B)
- Uses a 31x31 decision map stored in seqanmap.mat
- Automatically discards non-informative pairs (1,1 and 0,0)
- Identifies regions where:
  - A is better
  - B is better
  - There is no difference
  - Data remain in a twilight (inconclusive) zone
- Optional plotting of the decision map and the path followed
- Explicit handling of cases with no informative pairs

🛠️ Installation
1. Place seqanalysis.m and seqanmap.mat in a folder.
2. Add that folder to your MATLAB path using:
   addpath('path_to_seqanalysis_folder')
3. Ensure that seqanmap.mat contains a 31x31 numeric matrix called “map”.

▶️ Usage
Basic call:
    seqanalysis(x)

With plotting disabled:
    seqanalysis(x, 0)

With output:
    out = seqanalysis(x);

Where x is an N-by-2 matrix with rows [A B] and A,B in {0,1}.

🔣 Inputs
- x
  Type: N-by-2 numeric matrix.
  Description: paired outcomes for treatments A and B, with each entry equal to 0 or 1.

- flag (optional)
  Type: scalar (0 or 1).
  Description:
    1 = display the sequential decision chart (default)
    0 = perform the analysis without plotting.

📤 Outputs
- out
  Type: scalar.
  Description: final state code reached in the decision map:
    -1 : twilight zone (data not sufficient at the last step)
     0 : no difference between A and B
     1 : A is better
     2 : B is better
     3 : path tracking (internal code, normally not the final decision)
     4 : final point of movement (decision boundary)
    NaN : no informative pairs (all pairs were non-informative)

📘 Interpretation
Each informative pair (A,B) guides a step in the decision map:
- (1,0)    → a step favoring A (move up)
- (0,1)    → a step favoring B (move right)
Non-informative pairs:
- (1,1) and (0,0) are removed before starting the walk.
The path continues until:
- it exits the twilight zone into a region favoring A or B,
- it enters a region indicating no difference,
- or it stops with insufficient data in the twilight zone.
The final state code (out) and the plot (if enabled) show the conclusion of the sequential plan.

📝 Notes
- seqanalysis relies on the external file seqanmap.mat, which must contain the decision matrix map.
- The starting point in the map and the map structure are based on Bross’ original sequential medical plan.
- If all pairs are non-informative (only 0-0 or 1-1), the procedure cannot start and out is set to NaN.
- The function is intended for paired binary outcomes with exactly two treatments (A and B) per pair.

📚 Citation
Cardillo G. (2008). Sequential analysis test for paired binary data.  
GitHub: https://github.com/dnafinder/seqanalysis

👤 Author
Giuseppe Cardillo  
Email: giuseppe.cardillo.75@gmail.com  
GitHub: https://github.com/dnafinder

⚖️ License
This project is released under the MIT License.
