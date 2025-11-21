function out = seqanalysis(x, varargin)
%SEQANALYSIS Sequential analysis for paired binary outcomes (A vs B).
%
%   SEQANALYSIS(X) performs a sequential analysis on paired binary outcomes
%   from two treatments (A and B). Each row of X represents a pair of
%   patients, one treated with A and one with B, and each entry is:
%       1 = positive response
%       0 = negative response
%
%   Non-informative pairs, where both patients respond equally (0,0 or 1,1),
%   are discarded. The remaining informative pairs are used to walk through
%   a pre-defined decision map (stored in seqanmap.mat as a 31x31 matrix
%   called "map"), following Bross' sequential medical plan. The walk stops
%   when a decision boundary is reached or when all informative pairs are
%   exhausted.
%
%   SEQANALYSIS(X, FLAG) controls plotting:
%       FLAG = 1 (default) : display the sequential decision chart
%       FLAG = 0           : no plot (logic only)
%
%   OUT = SEQANALYSIS(...) returns the final state code reached in the map:
%       -1 : twilight zone (data not sufficient at last step)
%        0 : no difference between A and B
%        1 : A is better
%        2 : B is better
%        3 : path tracking (internal use; not returned as final decision)
%        4 : final point of movement (decision boundary)
%       NaN: no informative pairs (all pairs are 0-0 or 1-1)
%
%   The function requires the auxiliary file:
%       seqanmap.mat
%   containing:
%       map - a 31x31 numeric matrix with entries in {-1,0,1,2,3,4,NaN}
%   representing the Bross decision regions and the path coding.
%
%   ------------------------------------------------------------------
%   Syntax:
%       seqanalysis(X)
%       seqanalysis(X, FLAG)
%       OUT = seqanalysis(X)
%       OUT = seqanalysis(X, FLAG)
%
%   Inputs:
%       X    - N-by-2 numeric matrix with entries in {0,1}.
%              Column 1: response for treatment A
%              Column 2: response for treatment B
%
%       FLAG - (optional) plotting flag:
%                1 = show the sequential chart (default)
%                0 = suppress the plot
%
%   Output:
%       OUT  - scalar final state code, as described above.
%
%   Example:
%       % Results from a clinical comparison between therapies A and B.
%       % For each pair (A,B), 1 = positive, 0 = negative.
%       x = [1 1; 1 0; 0 0; 1 0; 1 0; 1 1; 0 1; 1 1; 1 0; 1 0; ...
%            1 0; 1 1; 1 0; 0 1; 0 0; 1 0; 1 0; 1 0; 1 1; 1 0];
%       seqanalysis(x);
%
%   Reference:
%       Bross IDJ. Sequential medical plans. Biometrics. 1952; 8: 186–206.
%
%   ------------------------------------------------------------------
%   Metadata:
%       Author : Giuseppe Cardillo
%       Email  : giuseppe.cardillo.75@gmail.com
%       GitHub : https://github.com/dnafinder
%       Created: 2008-01-01
%       Updated: 2025-11-21
%       Version: 2.0.0
%
%   Citation:
%       Cardillo G. (2008) Sequential analysis test for paired binary data.
%       GitHub: https://github.com/dnafinder/seqanalysis
%
%   License:
%       This code is distributed under the MIT License.
%   ------------------------------------------------------------------

%% Input error handling
p = inputParser;
p.FunctionName = 'seqanalysis';

addRequired(p, 'x', @(v) validateattributes( ...
    v, {'numeric'}, ...
    {'2d','ncols',2,'nonempty','integer','real','finite','nonnan','nonnegative'}));

addOptional(p, 'flag', 1, @(v) ...
    isnumeric(v) && isscalar(v) && ismember(v, [0 1]));

parse(p, x, varargin{:});
x    = p.Results.x;
flag = p.Results.flag;
clear p

% Ensure binary values {0,1}
assert(all(ismember(x(:), [0 1])), ...
    'seqanalysis:InvalidData', ...
    'All X values must be 0 or 1.');

%% Load the decision map
if exist('seqanmap.mat', 'file') ~= 2
    error('seqanalysis:MissingMap', ...
        ['The file seqanmap.mat was not found on the MATLAB path.\n' ...
         'It must contain the 31x31 decision matrix "map".']);
end

S = load('seqanmap.mat', 'map');
map = S.map;

% Basic sanity check on map size
if ~ismatrix(map) || any(size(map) ~= 31)
    error('seqanalysis:InvalidMap', ...
        'The variable "map" in seqanmap.mat must be a 31x31 matrix.');
end

%% Define colormap for plotting (if requested)
if flag == 1
    C = [ 255 255   0;  ... % yellow
          122  15 227;  ... % purple
          255   0   0;  ... % red
            0   0 255;  ... % blue
            0 255 255;  ... % cyan
            0 255   0   ... % green
        ] ./ 255;
end

%% Starting point in the decision map (fixed by the original method)
I = 30;
J = 1;

%% Delete concordant pairs (non-informative): (1,1) and (0,0)
x(x(:,1) == x(:,2), :) = [];

%% Special case: no informative pairs
if isempty(x)
    str = 'All pairs are non-informative: sequential plan cannot start.';
    
    if flag == 1
        % Plot the unchanged map with an informative title
        pcolor(map);
        colormap(C);
        axis ij square off;
        title(str, 'FontSize', 14);
    end
    
    if nargout == 1
        out = NaN;
    end
    return;
end

%% Sequential walk in the decision map
tmp = NaN;  % will be updated during the walk

for K = 1:size(x,1)
    if x(K,1) == 1
        % Only patient treated with A responds -> move up
        I = I - 1;
    else
        % Only patient treated with B responds -> move right
        J = J + 1;
    end
    
    tmp = map(I, J);  % current state before overwriting
    
    % In which zone of the matrix are we?
    switch map(I, J)
        case -1  % twilight zone
            if K == size(x,1)
                map(I, J) = 4;  % mark the end of movement
                str = 'Data are not enough to prove which is the better between A and B';
            end
            
        case 0   % no difference between A and B
            map(I, J) = 4;      % mark the end of movement
            str = 'There is no difference between A and B';
            break              % no more pairs required
            
        case 1   % A is better
            map(I, J) = 4;      % mark the end of movement
            str = 'A is the better one';
            break              % no more pairs required
            
        case 2   % B is better
            map(I, J) = 4;      % mark the end of movement
            str = 'B is the better one';
            break              % no more pairs required
    end
    
    % Track the path of movement in the matrix
    map(I, J) = 3;
end

%% Plot (if requested)
if flag == 1
    pcolor(map);        % "checkerboard" plot of the matrix
    colormap(C);        % set the colormap
    axis ij square off; % conventional orientation & aspect
    if exist('str','var')
        title(str, 'FontSize', 14);
    end
end

%% Output (if requested)
if nargout == 1
    out = tmp;
end

end
