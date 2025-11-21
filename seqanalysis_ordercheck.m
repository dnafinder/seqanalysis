function stats = seqanalysis_ordercheck(x, nperm, alpha, showProgress)
%SEQANALYSIS_ORDERCHECK Robustness of sequential analysis to ordering.
%
%   STATS = SEQANALYSIS_ORDERCHECK(X, NPERM) randomly permutes the rows
%   of X NPERM times, applies SEQANALYSIS (with plotting disabled), and
%   computes proportions and confidence intervals of each possible outcome.
%   A progress bar is shown by default.
%
%   STATS = SEQANALYSIS_ORDERCHECK(X, NPERM, ALPHA) sets the confidence
%   level for binomial CIs. Default ALPHA = 0.05.
%
%   STATS = SEQANALYSIS_ORDERCHECK(X, NPERM, ALPHA, SHOWPROGRESS)
%       SHOWPROGRESS = true  (default) → show waitbar
%       SHOWPROGRESS = false          → silent mode
%
%   ----------------------------------------------------------------------
%   Description
%   ----------------------------------------------------------------------
%   The output of SEQANALYSIS depends on the order of informative pairs.
%   This routine assesses the stability of that conclusion by Monte Carlo
%   permutation of pair order.
%
%   For each permutation, the function records the final decision code.
%
%   Possible codes:
%       -1  twilight / inconclusive
%        0  no difference
%        1  A better
%        2  B better
%       NaN no informative pairs
%
%   Binomial confidence intervals (Clopper–Pearson) are computed for the
%   proportion of each outcome.
%
%   ----------------------------------------------------------------------
%   Syntax
%   ----------------------------------------------------------------------
%       stats = seqanalysis_ordercheck(x, nperm)
%       stats = seqanalysis_ordercheck(x, nperm, alpha)
%       stats = seqanalysis_ordercheck(x, nperm, alpha, showProgress)
%
%   ----------------------------------------------------------------------
%   Inputs
%   ----------------------------------------------------------------------
%   X             N-by-2 matrix of 0/1 responses.
%   NPERM         Number of permutations.
%   ALPHA         Significance level for binomial CI. Default 0.05.
%   SHOWPROGRESS  Show waitbar or not (true/false).
%
%   ----------------------------------------------------------------------
%   Output (struct)
%   ----------------------------------------------------------------------
%   stats.codes       all raw outcomes (NPERM-by-1)
%   stats.freq        table with counts, proportions, and CI
%   stats.pA          proportion of runs returning code=1
%   stats.pB          proportion of runs returning code=2
%   stats.pNoDiff     proportion code=0
%   stats.pTwilight   proportion code=-1
%   stats.pNaN        proportion NaN
%   stats.CI_*        95% confidence intervals for each proportion
%
%   ----------------------------------------------------------------------
%   Example
%   ----------------------------------------------------------------------
%       stats = seqanalysis_ordercheck(x, 5000);
%       stats.freq
%       stats.pA
%       stats.CI_A
%
%   ----------------------------------------------------------------------
%   Citation
%   ----------------------------------------------------------------------
%   Cardillo G. (2025). seqanalysis_ordercheck: robustness to ordering.
%   GitHub: https://github.com/dnafinder/seqanalysis
%
%   ----------------------------------------------------------------------
%   Author
%   ----------------------------------------------------------------------
%   Author : Giuseppe Cardillo
%   Email  : giuseppe.cardillo.75@gmail.com
%   GitHub : https://github.com/dnafinder
%   Created: 2025-11-21
%   Updated: 2025-11-21
%   Version: 1.0.0
%
%   ----------------------------------------------------------------------
%   License
%   ----------------------------------------------------------------------
%   This code is released under the GNU GPL-3.0 license.
%

%% Defaults & validation
if nargin < 2 || isempty(nperm)
    nperm = 1000;
end
if nargin < 3 || isempty(alpha)
    alpha = 0.05;
end
if nargin < 4 || isempty(showProgress)
    showProgress = true;
end

validateattributes(x, {'numeric'}, ...
    {'2d','ncols',2,'nonempty','integer','real','finite','nonnan','nonnegative'});
assert(all(ismember(x(:),[0 1])));

validateattributes(nperm, {'numeric'}, {'scalar','integer','positive'});
validateattributes(alpha, {'numeric'}, {'scalar','real','>',0,'<',1});
showProgress = logical(showProgress);

n = size(x,1);
codes = NaN(nperm,1);

%% Progress bar
wb = [];
if showProgress
    wb = waitbar(0,'Running seqanalysis permutations...');
    if nperm > 200
        upd = max(1, round(nperm/100));
    else
        upd = 1;
    end
else
    upd = Inf;
end

%% Monte Carlo loop
try
    for k = 1:nperm
        idx = randperm(n);
        codes(k) = seqanalysis(x(idx,:),0);

        if showProgress && (mod(k,upd)==0 || k==nperm)
            if isvalid(wb)
                waitbar(k/nperm, wb, sprintf('%d of %d (%.1f%%)', ...
                    k, nperm, 100*k/nperm));
            end
        end
    end

    if showProgress && isvalid(wb)
        close(wb);
    end

catch ME
    if showProgress && ~isempty(wb) && isvalid(wb)
        close(wb);
    end
    rethrow(ME);
end

%% Summaries
allcodes = [-1; 0; 1; 2; NaN];
counts = zeros(size(allcodes));

for i = 1:numel(allcodes)
    if isnan(allcodes(i))
        counts(i) = sum(isnan(codes));
    else
        counts(i) = sum(codes == allcodes(i));
    end
end

props = counts / nperm;

%% CIs
ci = NaN(numel(allcodes),2);
for i = 1:numel(allcodes)
    [~, ci(i,:)] = binofit(counts(i), nperm, alpha);
end

labels = {'Twilight(-1)';'NoDiff(0)';'A_better(1)';'B_better(2)';'NoInfo(NaN)'};
freqTable = table(allcodes, counts, props, ci(:,1), ci(:,2), ...
    'VariableNames',{'Code','Count','Proportion','Lower_CI','Upper_CI'}, ...
    'RowNames', labels);

%% Output struct
stats.codes = codes;
stats.freq  = freqTable;

stats.pTwilight = props(1);
stats.pNoDiff   = props(2);
stats.pA        = props(3);
stats.pB        = props(4);
stats.pNaN      = props(5);

stats.CI_Twilight = ci(1,:);
stats.CI_NoDiff   = ci(2,:);
stats.CI_A        = ci(3,:);
stats.CI_B        = ci(4,:);
stats.CI_NaN      = ci(5,:);
end
