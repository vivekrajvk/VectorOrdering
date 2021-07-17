function [ N] = select_tree_shots(feature, Mtree )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
local=zscore(feature,0,1);
for idx=1:size(Mtree,1)
    
    [~,~,v]=find(Mtree(idx,:));
    if ~isempty(v) && ~cast(sum(v<1),'logical')
        %perform magnitude calculation row-wise(for each vector)
        ind=[];
        [~,ind]=sort(rssq( local( v,:) , 2),'descend');
        
        sshot=Mtree(idx,ind(1));
        N(idx)=sshot;
    end
end
Mtree=[];
end

