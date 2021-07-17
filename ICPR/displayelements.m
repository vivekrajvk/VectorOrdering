
function displayelements(thistree,resultantfilename,nodeindex)

%access the parent and node structures in 'thistree' and print the contents
%by referring to the parent child relationship. Order is from left to right
%i.e., from components greater to components lesser than root/central
%vector.
if ~exist('nodeindex','var')
    nodeindex=1;
end

%for each node in the tree
 i=nodeindex;
    %check if the children of the central vector have more than 5 elements,
    %childrens of root are from index 2 to 7.
  
    for j=i+1:i+3
        len=length ( thistree.Node{j,1} );
       if( len <=5 && len~=0)
           fileID = fopen(resultantfilename,'a');
           formatSpec = '%d,';
         
               fprintf(fileID,formatSpec,thistree.Node{j});
               fprintf(fileID,'\n');
         
           fclose(fileID);
           
          
           X=sprintf(' %d ',thistree.Node{j,1});
           disp(X);
       else
            displayelements(thistree,resultantfilename, find( thistree.Parent==j));
            
           
       end
    end

    X=sprintf('{ %d }',thistree.Node{i});
    disp(X);
    
    fileID = fopen(resultantfilename,'a');
           formatSpec = '%d,';
         
               fprintf(fileID,formatSpec,thistree.Node{i});
               fprintf(fileID,'\n');
         
           fclose(fileID);
    
    
    for j=i+4:i+6
        len=length ( thistree.Node{j,1} );
       if( len<=5 && len ~=0)
           
           fileID = fopen(resultantfilename,'a');
           formatSpec = '%d,';
         
               fprintf(fileID,formatSpec,thistree.Node{j});
               fprintf(fileID,'\n');
         
           fclose(fileID);
           
%          X=sprintf(' %d ',thistree.Node{j,1});
%          disp(X);
       else
            displayelements(thistree,resultantfilename,find( thistree.Parent==j) );
           
       end
    end
    
     


end
