# seqanalysis
Perform a sequential analysis to test two conditions.</br>
In statistics, sequential analysis or sequential hypothesis testing is
statistical analysis where the sample size is not fixed in advance.
Instead data is evaluated as it is collected, and further sampling is
stopped in accordance with a pre-defined stopping rule as soon as
significant results are observed. Thus a conclusion may sometimes be
reached at a much earlier stage than would be possible with more
classical hypothesis testing or estimation, at consequently lower
financial and/or human cost.
I. Bross, Sequential medical plans. Biometrics. 1952; 8:186

Syntax:   seqanalysis(x)

Inputs:
  X - Nx2 data matrix
Outputs:
  - Sequential analysis plots

  Example:
During a sperimentation between two terapies, two drugs A and B were
administered to patients couples (one received A, the other B). A
positive result in a patient by the drug is indicated by 1; a negative
result by 0. Result are resumed in this table:

Couple    A   B   Note
  1       1   1   Non informative
  2       1   0   All for A
  3       0   0   Non informative
  4       1   0   All for A
  5       1   0   All for A
  6       1   1   Non informative
  7       0   1   All for B
  8       1   1   Non informative
  9       1   0   All for A
  10      1   0   All for A
  11      1   0   All for A
  12      1   1   Non informative
  13      1   0   All for A
  14      0   1   All for B
  15      0   0   Non informative
  16      1   0   All for A
  17      1   0   All for A
  18      1   0   All for A
  19      1   1   Non informative
  20      1   0   All for A

The algorithm will discard all non informative couple; then, it will
start to move along the chart. If it goes out the twilight zone, the
sperimental plan can be stopped and non more couple will be required.
To test the function with these data:
   x=[1 1; 1 0; 0 0; 1 0; 1 0; 1 1; 0 1; 1 1; 1 0; 1 0; 1 0; 1 1; 1 0; ...
0 1; 0 0; 1 0; 1 0; 1 0; 1 1; 1 0];
seqanalysis(x)

          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2008) Sequential analysis test.
http://www.mathworks.com/matlabcentral/fileexchange/22204
