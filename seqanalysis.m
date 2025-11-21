function out = seqanalysis(x, flag)
%SEQANALYSIS Sequential analysis for paired binary outcomes.
%
%   SEQANALYSIS(X) performs Bross sequential analysis on paired binary
%   outcomes for treatments A and B. X must be an N-by-2 matrix containing
%   0/1 responses for each treatment within each pair.
%
%   SEQANALYSIS(X, FLAG) controls plotting:
%       FLAG = 1  (default) → show the sequential pathway on the map
%       FLAG = 0            → run silently (no plot)
%
%   ----------------------------------------------------------------------
%   Description
%   ----------------------------------------------------------------------
%   Pairs where both A and B have the same response (0–0 or 1–1) are
%   “non-informative” and are removed. Remaining informative pairs are
%   processed in order. For each pair:
%
%       • If A=1 and B=0 → move "up" in the decision matrix.
%       • If A=0 and B=1 → move "right".
%
%   The map used for navigation is stored in seqanmap.mat and contains
%   Bross’ decision regions:
%
%       -1  twilight region (inconclusive)
%        0  no difference between treatments
%        1  treatment A is better
%        2  treatment B is better
%
%   Traversal stops as soon as a conclusive region is reached.
%
%   If no informative pairs exist, SEQANALYSIS returns:
%       out = NaN
%       and produces a clear message (if FLAG=1).
%
%   ----------------------------------------------------------------------
%   Syntax
%   ----------------------------------------------------------------------
%       out = seqanalysis(x)
%       out = seqanalysis(x, flag)
%
%   ----------------------------------------------------------------------
%   Inputs
%   ----------------------------------------------------------------------
%   X       N-by-2 matrix of 0/1 responses.
%   FLAG    Show plot (1) or silent mode (0). Default = 1.
%
%   ----------------------------------------------------------------------
%   Output
%   ----------------------------------------------------------------------
%   OUT     Final decision code:
%               -1  twilight / inconclusive
%                0  no difference
%                1  A better
%                2  B better
%               NaN no informative pairs
%
%   ----------------------------------------------------------------------
%   Example
%   ----------------------------------------------------------------------
%       x=[1 1;1 0;0 0;1 0;1 0;1 1;0 1;1 1;1 0;1 0;...
%          1 0;1 1;1 0;0 1;0 0;1 0;1 0;1 0;1 1;1 0];
%       seqanalysis(x)
%
%   ----------------------------------------------------------------------
%   Citation
%   ----------------------------------------------------------------------
%   Cardillo G. (2008). Sequential analysis test.
%   GitHub: https://github.com/dnafinder/seqanalysis
%
%   ----------------------------------------------------------------------
%   Author
%   ----------------------------------------------------------------------
%   Author : Giuseppe Cardillo
%   Email  : giuseppe.cardillo.75@gmail.com
%   GitHub : https://github.com/dnafinder
%   Created: 2008-01-01
%   Updated: 2025-11-21
%   Version: 2.0.0
%
%   ----------------------------------------------------------------------
%   License
%   ----------------------------------------------------------------------
%   This code is released under the GNU GPL-3.0 license.
%

%% Input handling
if nargin < 2, flag = 1; end

validateattributes(x, {'numeric'}, ...
    {'nonempty','integer','real','finite','nonnan','ncols',2});
assert(all(ismember(x(:),[0 1])), ...
    'All X values must be 0 or 1.');

validateattributes(flag, {'numeric','logical'}, ...
    {'scalar'}, mfilename, 'flag');

flag = logical(flag);

%% Load map
load seqanmap.mat map

%% Remove non-informative pairs
x(x(:,1) == x(:,2), :) = [];

if isempty(x)
    if flag
        disp('No informative pairs available. Analysis cannot proceed.');
    end
    out = NaN;
    return
end

%% Initial position
I = 30; 
J = 1;

%% Colors for plot
if flag
    C = [255 255 0;
         122  15 227;
         255   0   0;
           0   0 255;
           0 255 255;
           0 255   0]./255;
end

%% Sequential navigation
finalValue = NaN;

for k = 1:size(x,1)

    if x(k,1) == 1
        I = I - 1;
    else
        J = J + 1;
    end

    region = map(I,J);

    switch region
        case -1        % Twilight
            finalValue = -1;
            if k == size(x,1)
                map(I,J) = 4;
            else
                map(I,J) = 3;
            end

        case 0         % No difference
            finalValue = 0;
            map(I,J) = 4;
            break

        case 1         % A better
            finalValue = 1;
            map(I,J) = 4;
            break

        case 2         % B better
            finalValue = 2;
            map(I,J) = 4;
            break
    end

    map(I,J) = 3;
end

%% Plot
if flag
    pcolor(map);
    colormap(C);
    axis ij square off

    switch finalValue
        case -1, title('Inconclusive: twilight zone');
        case 0,  title('No difference between A and B');
        case 1,  title('A is better');
        case 2,  title('B is better');
        otherwise
            title('No informative pairs');
    end
end

if nargout, out = finalValue; end
end
