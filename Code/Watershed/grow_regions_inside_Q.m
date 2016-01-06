function [CBnplus1, dam] = grow_regions_inside_Q(CB, Q)
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

CBnplus1 = CB;
while(~isequal(Q, ((CBnplus1 > 0) & Q) | dam)),
    newq  = Q & (CBnplus1 > 0);
    nlist = get_number_list(CBnplus1(newq));

    tmp = zeros(size(CB));
    for k=nlist;
        imdk = imdilate(CBnplus1==k, nhood) & Q;
        tmp  = tmp + imdk;
    end;

    dam = tmp > 1;
    tmp = CBnplus1;
    for k=nlist;
        imdk = imdilate(CBnplus1==k, nhood) & Q & (CBnplus1 == 0);
        tmp(imdk) = k;
    end;
    CBnplus1 = tmp;
end;
