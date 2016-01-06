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

CBnplus1 = CB;
while(~isequal(Q, ((CBnplus1 > 0) & Q) | dam)),
    newq  = Q & (CBnplus1 > 0);
    nlist = get_number_list(CBnplus1(newq));

    tmp1 = zeros(size(CB));
    tmp2 = CBnplus1;
    for k=nlist;
        imdk = imdilate(CBnplus1==k, nhood) & Q;
        tmp1 = tmp1 + imdk;
        tmp2(imdk & (CBnplus1 == 0)) = k;
    end;

    dam = tmp1 > 1;
    CBnplus1 = tmp2;
end;
