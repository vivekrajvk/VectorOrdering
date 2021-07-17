function [ ResultTree,NoofSubtrees ] = CompCluster( featureVectors)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
local=featureVectors;

clusters=Rordering(local);
clustree=struct('Level',[],'clusters',clusters);

%recursively find cluster center for each row of clustree(main
%cluster) and order the vectors around the
%center based on the number of components greater, lesser or equal
%to the central vector.

%clusters is a matix of 7 rows x many columns
%clustree is a array of clusters
flag=1;
%index to clustree rows.
clusrows=1;
while  flag==1
    flag=0;
    %index for writing the resultant clusters to a row of clustree.
    rows=clusrows+1;
    cols=1;
    %index to the colums of clustree structure
    for cluscols=1:size(clustree(clusrows,:),2)
        
        % for each rows of clusters
        for loopidx=1:size(clustree(clusrows,cluscols).clusters,1)
            if( nnz(clustree(clusrows,cluscols).clusters(loopidx,:)) >5 && loopidx~=4)
                subsetindexes= clustree(clusrows,cluscols).clusters( loopidx,find(clustree(clusrows,cluscols).clusters(loopidx,:)) );
                subset=local ( subsetindexes,:);
                %store the resultant cluster in the destination
                %location given by 'rows' and 'cols' which point to
                %clustree location
                clustree(rows,cols).clusters=Rordering(subset,subsetindexes);
                flag=1;
                cols=cols+1;
            end
        end
    end
    clusrows=clusrows+1;
end

% combine clusters into single matrix
%create clusters from clustree, starting from the bottom most
%sub-tree. use t1=tree(<input shot indexs>); later add 3 left trees
%and 3 right trees t1=t1.addnode(1,[]) then t1=t1.addnode(1,[23 45])
% attach previously constructed trees to the main tree using graft
%t2=graft(<position>,t1);
temp=tree([]);
trees=struct('t',temp);
treeindex=1;
for clsrows=size(clustree,1):-1:1
    for clscols=size(clustree,2):-1:1
        %extract non-zero elements in the row and assign it to tree
        %node
        if isempty(clustree(clsrows,clscols).clusters)
            
            continue;
        else
            %construct the tree
            
            trees(treeindex).t=tree( [clustree(clsrows,clscols).clusters(4,[find(clustree(clsrows,clscols).clusters(4,:))]) ]);
            
            for i=[1 2 3 5 6 7]
                if( nnz(clustree(clsrows,clscols).clusters(i,:)))
                    %add only if row has any non-zero element
                    trees(treeindex).t=trees(treeindex).t.addnode(1, [clustree(clsrows,clscols).clusters(i,[find(clustree(clsrows,clscols).clusters(i,:))])]   );
                else
                    %else add empty node.
                    trees(treeindex).t=trees(treeindex).t.addnode(1,[]);
                end
                
            end
            treeindex=treeindex+1;
            
        end
        
    end
end


% Grafting the subtrees to main tree
for i=1:length(trees)-1
    %search for the super tree which contains the root element of
    %the subtree
    for j=i+1: length(trees)
        gotit=0;
        %loop through all the nodes of the tree
        for k=2:7
            % if nnz(  (trees(i).t.get(1) == trees(j).t.get(k))  )
            if ~isempty( intersect( trees(i).t.get(1), trees(j).t.get(k) )   )
                trees(j).t=trees(j).t.graft(k,trees(i).t);
                gotit=1;
                break;
            end
            
        end
        if(gotit)
            break;
        end
        
    end
end

ResultTree=trees( length(trees) ).t;
NoofSubtrees=length(trees);

%displayelements(ResultTree,1);
end

