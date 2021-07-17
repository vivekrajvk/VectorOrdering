function selectedshots=playskim(filepath,selshots,skimratio)
%input the selected shots file along with the required skim length in
%percentage of original length.


shotboundaryfile=strrep(filepath,'.avi','.mat');
load(shotboundaryfile);
result=indices;

if exist('selshots','var')    
selectedshots=selshots;
else
    selectedshots=[1:1:length(indices)];
end

%try taking shots from end of selected shots
% selectedshots=flipdim(selectedshots,2);


skimlength=0;

%videofilepath=strrep(shotboundaryfile,'.mat','.avi');
obj = VideoReader(filepath);
props=get(obj);

if exist('skimratio','var')

    % select shots until the given skim ratio  is satisfied
    countframes=0;
    newselectedshots=[];
    sindx=1;
    
    requiredlength=(skimratio/100)* props.Duration;
    requiredlength=round(requiredlength*props.FrameRate);
    sprintf('for the given skimratio %d %% no. of frames to be selected is %d',skimratio,requiredlength)
    for lidx=1:length(selectedshots)
        
             if ((selectedshots(lidx)-1)==0) 
                 lbegin=1;%beginning frame of the shot
             else
                 lbegin=result(1,selectedshots(lidx)-1 );
             end
             
             %ending frame of the shot
             lending=result(1,selectedshots(lidx) );
             %take care of invalid shots
             if lending-lbegin>0
                 countframes=countframes+(lending-lbegin);
                 newselectedshots(sindx)=selectedshots(lidx);
                 sindx=sindx+1;
             end   
             
             if countframes>=requiredlength
                 break;
             end
                 
        
        
   
    end  %end of skim ratio 
    
    selectedshots=[];
    selectedshots=newselectedshots;
end

shotstoplay=sort(selectedshots);

videoPlayer = vision.VideoPlayer;

for shotloop=1:length(shotstoplay)

    if ((shotstoplay(shotloop)-1)==0) 
        begin=1;%beginning frame of the shot
    else
        begin=result(1,shotstoplay(shotloop)-1 );
           
    end
    
    %ending frame of the shot
    ending=result(1,shotstoplay(shotloop) );
    %take care of invalid shots
    if ending-begin<1
        continue;
    end
    skimlength=skimlength+(ending-begin)/props.FrameRate;
    
%     for loop=begin:ending
%                frame = read(obj,loop);
%                step(videoPlayer,frame);
%                pause(0.02);
%     end
%       pause;
end

%release(obj);
release(videoPlayer);

sprintf('skimlength is %f seconds and video length is %f seconds',skimlength,props.Duration)

end