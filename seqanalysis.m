function seqanalysis(x)
% SEQANALYSIS Perform a sequential analysis to test two conditions.
% In statistics, sequential analysis or sequential hypothesis testing is
% statistical analysis where the sample size is not fixed in advance.
% Instead data is evaluated as it is collected, and further sampling is
% stopped in accordance with a pre-defined stopping rule as soon as
% significant results are observed. Thus a conclusion may sometimes be
% reached at a much earlier stage than would be possible with more
% classical hypothesis testing or estimation, at consequently lower
% financial and/or human cost.
% I. Bross, Sequential medical plans. Biometrics. 1952; 8:186
% 
% Syntax:   seqanalysis(x)
% 
% Inputs:
%   X - Nx2 data matrix
% Outputs:
%   - Sequential analysis plots
% 
%   Example:
% During a sperimentation between two terapies, two drugs A and B were
% administered to patients couples (one received A, the other B). A
% positive result in a patient by the drug is indicated by 1; a negative
% result by 0. Result are resumed in this table:
% 
% Couple    A   B   Note
%   1       1   1   Non informative
%   2       1   0   All for A
%   3       0   0   Non informative
%   4       1   0   All for A
%   5       1   0   All for A
%   6       1   1   Non informative
%   7       0   1   All for B
%   8       1   1   Non informative
%   9       1   0   All for A
%   10      1   0   All for A
%   11      1   0   All for A
%   12      1   1   Non informative
%   13      1   0   All for A
%   14      0   1   All for B
%   15      0   0   Non informative
%   16      1   0   All for A
%   17      1   0   All for A
%   18      1   0   All for A
%   19      1   1   Non informative
%   20      1   0   All for A
% 
% The algorithm will discard all non informative couple; then, it will
% start to move along the chart. If it goes out the twilight zone, the
% sperimental plan can be stopped and non more couple will be required.
% To test the function with these data:
%    x=[1 1; 1 0; 0 0; 1 0; 1 0; 1 1; 0 1; 1 1; 1 0; 1 0; 1 0; 1 1; 1 0; ...
% 0 1; 0 0; 1 0; 1 0; 1 0; 1 1; 1 0];
% seqanalysis(x)
% 
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
% 
% To cite this file, this would be an appropriate format:
% Cardillo G. (2008) Sequential analysis test.
% http://www.mathworks.com/matlabcentral/fileexchange/22204

%Input error handling
p = inputParser;
addRequired(p,'x',@(x) validateattributes(x,{'numeric'},{'nonempty','integer','real','finite','nonnan','nonnegative'}));
parse(p,x);
assert(all(ismember(p.Results.x(:),[0 1])),'Warning: all X values must be 0 or 1')
x=p.Results.x; 
clear p 

%define the colormap
C=[ 255 255 0; ... %yellow
    122 15 227; ... %purple
    255 0 0; ... %red
    0 0 255; ... %blu
    0 255 255; ... %cyan
    0 255 0; ... %green
    ]./255;
load seqanmap.mat map %load the model
I=30; J=1; %set the starting point of the matrix

x(x(:,1)==x(:,2),:)=[]; %delete concordant response
for K=1:size(x,1)
    if x(K,1) %If only the patient treated with the A drug responds...
        I=I-1; %...go up in the matrix
    else %If only the patient treated with the B drug responds...
        J=J+1; %...go right in the matrix
    end
    switch map(I,J) %in which zone of the matrix are you?
        case -1 %in the twilight zone
            if K==size(x,1) %if there are no more couples...
                map(I,J)=4; %track the end of movent
                str='Data are not enough to prove which is the better between A and B';
            end
        case 0 %no difference between A and B
            map(I,J)=4; %track the end of movent
            str='There is no difference between A and B';
            break %no more couple are required.
        case 1 %A is the better one
            map(I,J)=4; %track the end of movent
            str='A is the better one';
            break %no more couple are required.
        case 2 %B is the better one
            map(I,J)=4; %track the end of movent
            str='B is the better one';
            break %no more couple are required.
    end
    map(I,J)=3; %track the movement in the matrix
end

%display results
pcolor(map) %"checkboard" plot of the matrix
colormap(C) %set the colormap
axis ij square off %set the axis
title(str,'FontSize',14) %display results