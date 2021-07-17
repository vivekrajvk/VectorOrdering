function [ treecollection ] = RorderandLinear_15_Dataset()
% Performs Rorder and Linear skim selection of shots for  given skim
%ratio. Gives the result for the whole dataset as treecollection structure.

%This is the code use in paper [Vivekraj V. K., Balasubramanian Raman, and Debashis Sen, “Vector r-ordering based
% selection of segments for video skimming,” in 23rd International Conference on Pattern
% Recognition (ICPR). IEEE, 2016, pp. 871–876.]

% code written in Matlab R2014

% Dependency: tree data structure from tinevez-matlab-tree-3d13d15

% dataset path
dr='.\data';

list=dir([dr,'\*.avi']);

treecollection=struct('videoname','','subtrees',0,'tree',tree(),'shotcollection','','extractedfromtree','','linearfusion','','LinfusionScores','','Rorder_skim','','Linear_skim','');
for x=1:length(list)
        filename=strcat(dr,'\',list(x).name)  
        load(strrep(filename,'.avi','_features.mat'));
        %load(filename);    
        [resTree,nosubtree]=CompCluster(features);
         treecollection(x).videoname=filename;
         treecollection(x).tree=resTree;
         treecollection(x).subtrees=nosubtree;
         extractedfilename=strrep(filename,'.avi','.dat');
         displayelements(resTree,extractedfilename,1);
         treecollection(x).extractedfromtree=csvread(extractedfilename);
         delete(extractedfilename);
         %%
         treecollection(1,x).shotcollection=[];
         treecollection(1,x).shotcollection=select_tree_shots(features,treecollection(x).extractedfromtree);
         
         %linear fusion of feature values...
         local=round(normalize(features),4);
         [scores,orgindx]=sort(sum(abs(local),2),'descend');
         treecollection(1,x).linearfusion=[];
         treecollection(1,x).linearfusion=orgindx';
         treecollection(1,x).LinfusionScores=ceil(scores');
         
         treecollection(1,x).Linear_skim=(playskim(treecollection(1,x).videoname,treecollection(1,x).linearfusion,15));
         treecollection(1,x).Rorder_skim=(playskim(treecollection(1,x).videoname,treecollection(1,x).shotcollection,15));
%        
% save('framesresult','treecollection')
end 


end

