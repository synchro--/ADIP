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

CBnplus1 = CB; % para no tocar CB 
while(~isequal(Q, ((CBnplus1 > 0) & Q) | dam)), % la union de los puntos que pertenecen a un CB o que estan en una presa tienen que ser igual a q. continua hasta que esté lleno, hasta que se hayan llenado del todo. or dam a lo mejor se puede tocar
    newq  = Q & (CBnplus1 > 0); % 
    nlist = get_number_list(CBnplus1(newq)); % nqint again

    tmp1 = zeros(size(CB)); % posiciones de dam
    tmp2 = CBnplus1; % nuevas posiciones de CB. lo inicializamos asi
    for k=nlist; % para los cb que esten en q
        imdk = imdilate(CBnplus1==k, nhood) & Q; % no puede salir de q cuando se dilata. 
        tmp1 = tmp1 + imdk;  % le suma estos puntos
        tmp2(imdk & (CBnplus1 == 0)) = k; % ahora pertenecen al CB k. 
    end;

    dam = tmp1 > 1; % se han solapado dos dilataciones
    CBnplus1 = tmp2; 
end;
