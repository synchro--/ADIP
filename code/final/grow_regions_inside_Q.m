function [CBnplus1, dam] = grow_regions_inside_Q2(CB, Q)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   [CBnplus1, dam] = grow_regions_inside_Q(CB, Q)
%
%   Grows the connected regions of CB that lie inside Q
%
%   Inputs:     CB -  Matrix with the labelled regions
%               Q  -  Binary matrix with the connected region Q
%
%   Outputs:   CBnplus1 - Matrix with the grown labelled regions
%              dam      - Binary matrix identifying the dam points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nhood = strel([1 1 1; 1 1 1; 1 1 1]);
dam   = zeros(size(CB));

CBnplus1 = CB; %CBnplus1 is the matrix that will be updated 
while(~isequal(Q, ((CBnplus1 > 0) & Q) | dam)), %
    newq  = Q & (CBnplus1 > 0); % 
    nlist = get_number_list(CBnplus1(newq)); % find the amount of connected set already flooded 

    tmp1 = zeros(size(CB)); % find the coordinates of the points where a dam will be built
    tmp2 = CBnplus1; % initializing to find the new coordinates
    for k=nlist; % for each point in the list 
        imdk = imdilate(CBnplus1==k, nhood) & Q; % the dilation must belong to the set of connected region (& Q = intersection) 
        tmp1 = tmp1 + imdk;  % growing the set
        tmp2(imdk & (CBnplus1 == 0)) = k; 
    end;

    dam = tmp1 > 1;
    CBnplus1 = tmp2; 
end;
