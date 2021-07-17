function clusters=Rordering( local,indexarray)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%
%

% %correction for floating point truncation to four decimal places
% fileID = fopen('zscore.dat','w');
% formatSpec = '%6.4f,';
% for indx=1:size(local,1)
%     fprintf(fileID,formatSpec,local(indx,:));
%     fprintf(fileID,'\n');
% end
% fclose(fileID);
% 
% local=csvread('zscore.dat');
% local(:,6)=[];
% 
% %end of correction

%if number of vectors are less than or equal five return them
if size(local,1)<=5
    clusters=zeros(7,size(local,1));
    clusters(1,:)=[1:1:size(local,1)];
    return;
end

%end of correction 2
try
dist=pdist2(local,local,'mahalanobis');
catch ME
   if (strcmp(ME.identifier,'stats:pdist2:InvalidCov'))
       dist=pdist2(local,local,'euclidean');
   else
       rethrow(ME);
   end
end
rorder=sum(dist);
[~,indexes]=sort(rorder);

clusters=zeros(7,size(local,1));
%clusters=[];
%compare component wise equality, > or <
for loop=1:length(indexes)
    val=sum( local(loop,:)==local(indexes(1),:) );
    if val==5
        % store the index of feature
        clusters(4,nnz(clusters(4,:))+1)=loop;
        
    else
        val=sum( local(loop,:)<=local(indexes(1),:) );
        
        switch(val)
            case 0
                clusters(val+1, nnz(clusters(val+1,:))+1)=loop;
            case 1
                clusters(val+1, nnz(clusters(val+1,:))+1)=loop;
            case 2
                clusters(val+1, nnz(clusters(val+1,:))+1)=loop;
            case 3
                clusters(val+2, nnz(clusters(val+2,:))+1)=loop;
            case 4
                clusters(val+2, nnz(clusters(val+2,:))+1)=loop;
            case 5
                clusters(val+2, nnz(clusters(val+2,:))+1)=loop;
                
                
        end
    end
end

if exist('indexarray','var')
    clusters=replacetooriginal(clusters,indexarray);
end

end

%     %reshape the matrox to one dimensional
%     temp=reshape(veccluster,1,[]);
%     %remove 0 entries
%     selectedshots=temp(find(temp));
%     %setdiff(indexes,veccluster)
%     selectedshotsfilepath=strrep(featurematrixpath,'_features.mat','_selectedshots');
%     save(selectedshotsfilepath,'selectedshots');

function cluster=replacetooriginal(cluster,subsetindexes)
%replaces the index values of the subset of feature vectors to the index of
%the shot they represent in the feature vector.

for lidx=1: size(cluster,1)
    counts=nnz(cluster(lidx,:));
    for l2idx=1: counts
        cluster(lidx,l2idx)=subsetindexes(   cluster(lidx,l2idx)  );
    end
    
end
end


