clear all; close all; clc;
sizec=40030;
namesvar=[{'map1km'},{'map2km'},{'map4km'},{'map8km'},{'map16km'},{'map32km'},{'map64km'}];

for pp=2:7    
    sizec=ceil(sizec/2);
    sizer=ceil(sizec/2);
    scalefactor=sizec/360;
    mymapstates=zeros(sizer,sizec);
    
    states = shaperead('./province/PROVINCE.SHP', 'UseGeoCoords', true);    
    for k=1:length(states)
    %     for l=1:length(states(k).Lon)
    %         nstates.Lat=states(k).Lat(l)+90;
    %         nstates.Lon=states(k).Lon(l)+180;
    %         plot(states(k).Lon(l),states(k).Lat(l),'.'); hold on; 
    %     end

        nstates(k).Lat=states(k).Lat+90;
        nstates(k).Lat=180-nstates(k).Lat;
        nstates(k).Lon=states(k).Lon+180;
        nstates(k).Lon((nstates(k).Lon(:)<0))=360+nstates(k).Lon((nstates(k).Lon(:)<0));    
        nstates(k).Lat=floor(nstates(k).Lat.*scalefactor);
        nstates(k).Lon=floor(nstates(k).Lon.*scalefactor);
        nstates(k).Lon((nstates(k).Lon(:)<1))=1;        
        nstates(k).Lat((nstates(k).Lat(:)<1))=1;    
        nstates(k).Lon((nstates(k).Lon(:)>sizec))=sizec;        
        nstates(k).Lat((nstates(k).Lat(:)>sizer))=sizer;    
        for l=1:length(nstates(k).Lat)-1
            [ind, label] = drawline([nstates(k).Lat(l) nstates(k).Lon(l)],[nstates(k).Lat(l+1) nstates(k).Lon(l+1)],[sizer sizec]);
            mymapstates(ind)=255;
    %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        end
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        ind=sub2ind(size(mymapstates),nstates(k).Lat(:), nstates(k).Lon(:));
        mymapstates(ind(~isnan(ind)))=255;
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        %plot(nstates(k).Lon,nstates(k).Lat,'.'); hold on; 
    end

    states = shaperead('./mexico-states/mexbdy.shp', 'UseGeoCoords', true);
    for k=1:length(states)
    %     for l=1:length(states(k).Lon)
    %         nstates.Lat=states(k).Lat(l)+90;
    %         nstates.Lon=states(k).Lon(l)+180;
    %         plot(states(k).Lon(l),states(k).Lat(l),'.'); hold on; 
    %     end

        nstates(k).Lat=states(k).Lat+90;
        nstates(k).Lat=180-nstates(k).Lat;
        nstates(k).Lon=states(k).Lon+180;
        nstates(k).Lon((nstates(k).Lon(:)<0))=360+nstates(k).Lon((nstates(k).Lon(:)<0));    
        nstates(k).Lat=floor(nstates(k).Lat.*scalefactor);
        nstates(k).Lon=floor(nstates(k).Lon.*scalefactor);
        nstates(k).Lon((nstates(k).Lon(:)<1))=1;        
        nstates(k).Lat((nstates(k).Lat(:)<1))=1;    
        nstates(k).Lon((nstates(k).Lon(:)>sizec))=sizec;        
        nstates(k).Lat((nstates(k).Lat(:)>sizer))=sizer;    
        for l=1:length(nstates(k).Lat)-1
            [ind, label] = drawline([nstates(k).Lat(l) nstates(k).Lon(l)],[nstates(k).Lat(l+1) nstates(k).Lon(l+1)],[sizer sizec]);
            mymapstates(ind)=255;
    %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        end
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        ind=sub2ind(size(mymapstates),nstates(k).Lat(:), nstates(k).Lon(:));
        mymapstates(ind(~isnan(ind)))=255;
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        %plot(nstates(k).Lon,nstates(k).Lat,'.'); hold on; 
    end

    states = shaperead('usastatehi', 'UseGeoCoords', true);
    for k=1:length(states)
    %     for l=1:length(states(k).Lon)
    %         nstates.Lat=states(k).Lat(l)+90;
    %         nstates.Lon=states(k).Lon(l)+180;
    %         plot(states(k).Lon(l),states(k).Lat(l),'.'); hold on; 
    %     end

        nstates(k).Lat=states(k).Lat+90;
        nstates(k).Lat=180-nstates(k).Lat;
        nstates(k).Lon=states(k).Lon+180;
        nstates(k).Lon((nstates(k).Lon(:)<0))=360+nstates(k).Lon((nstates(k).Lon(:)<0));    
        nstates(k).Lat=floor(nstates(k).Lat.*scalefactor);
        nstates(k).Lon=floor(nstates(k).Lon.*scalefactor);
        nstates(k).Lon((nstates(k).Lon(:)<1))=1;        
        nstates(k).Lat((nstates(k).Lat(:)<1))=1;    
        nstates(k).Lon((nstates(k).Lon(:)>sizec))=sizec;        
        nstates(k).Lat((nstates(k).Lat(:)>sizer))=sizer;    
        for l=1:length(nstates(k).Lat)-1
            [ind, label] = drawline([nstates(k).Lat(l) nstates(k).Lon(l)],[nstates(k).Lat(l+1) nstates(k).Lon(l+1)],[sizer sizec]);
            mymapstates(ind)=255;
    %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        end
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        ind=sub2ind(size(mymapstates),nstates(k).Lat(:), nstates(k).Lon(:));
        mymapstates(ind(~isnan(ind)))=255;
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        %plot(nstates(k).Lon,nstates(k).Lat,'.'); hold on; 
    end
    
    states = shaperead('/home/pablorp80/Downloads/TM_WORLD_BORDERS-0.3/TM_WORLD_BORDERS-0.3.shp', 'UseGeoCoords', true);
    for k=1:length(states)
        if ~strcmp(states(k).NAME,'Canada') && ~strcmp(states(k).NAME,'United States') && ~strcmp(states(k).NAME,'Mexico')
            nstates(k).Lat=states(k).Lat+90;
            nstates(k).Lat=180-nstates(k).Lat;
            nstates(k).Lon=states(k).Lon+180;
            nstates(k).Lon((nstates(k).Lon(:)<0))=360+nstates(k).Lon((nstates(k).Lon(:)<0));    
            nstates(k).Lat=floor(nstates(k).Lat.*scalefactor);
            nstates(k).Lon=floor(nstates(k).Lon.*scalefactor);
            nstates(k).Lon((nstates(k).Lon(:)<1))=1;        
            nstates(k).Lat((nstates(k).Lat(:)<1))=1;    
            nstates(k).Lon((nstates(k).Lon(:)>sizec))=sizec;        
            nstates(k).Lat((nstates(k).Lat(:)>sizer))=sizer;    
            for l=1:length(nstates(k).Lat)-1
                [ind, label] = drawline([nstates(k).Lat(l) nstates(k).Lon(l)],[nstates(k).Lat(l+1) nstates(k).Lon(l+1)],[sizer sizec]);
                mymapstates(ind)=255;
        %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
            end
        %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
            ind=sub2ind(size(mymapstates),nstates(k).Lat(:), nstates(k).Lon(:));
            mymapstates(ind(~isnan(ind)))=255;
        %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
            %plot(nstates(k).Lon,nstates(k).Lat,'.'); hold on; 
        end
    end
    
    eval(['imwrite(uint8(mymapstates),''' cell2mat(namesvar(pp)) '.png'',''png'');']);
    clear mymapstates
end 
