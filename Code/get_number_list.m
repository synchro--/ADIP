function numlist = get_number_list(vector);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   numlist = get_number_list(vector)
%
%   Gets the list of all numbers contained in vector
%
%   Inputs:     vector - A 1D array of numbers
%
%   Outputs:    numlist - a vector containing a list of all the different
%                         numbers found in vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = 1;
numlist = min(vector);
for n=min(vector)+1:max(vector);
    if length(find(vector==n)),
        numlist(k+1) = n;
        k = k+1;
    end;
end;
