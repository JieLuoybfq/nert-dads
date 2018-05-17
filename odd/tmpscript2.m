clear all; close all; clc;
sizec=5004;
namesvar=[{'map1km'},{'map2km'},{'map4km'},{'map8km'},{'map16km'},{'map32km'},{'map64km'}];
nmaxlat=45;
nminlat=25;
nmaxlon=-90;
nminlon=-110;
for pp=5:7    
    sizec=ceil(sizec/2);
    sizer=ceil(sizec/2);
    scalefactor=sizec/360;
    maxlat=180-(nmaxlat+90);
    minlat=180-(nminlat+90);
    maxlon=nmaxlon+180; if maxlon<0; maxlon=360+maxlon; end;
    minlon=nminlon+180; if minlon<0; minlon=360+minlon; end;
    maxlat=floor(maxlat*scalefactor); if maxlat<1; maxlat=1; end; if maxlat>sizer; maxlat=sizer; end;
    minlat=floor(minlat*scalefactor); if minlat<1; minlat=1; end; if minlat>sizer; minlat=sizer; end;
    maxlon=floor(maxlon*scalefactor); if maxlon<1; maxlon=1; end; if maxlon>sizec; maxlon=sizec; end;
    minlon=floor(minlon*scalefactor); if minlon<1; minlon=1; end; if minlon>sizec; minlon=sizec; end;
    malon=max([minlon maxlon]);
    milon=min([minlon maxlon]);
    malat=max([minlat maxlat]);
    milat=min([minlat maxlat]);
    mymapstates=zeros((malat-milat)+1,(malon-milon)+1);
    
    
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
            if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                [ind, label] = drawline([(nstates(k).Lat(l)-milat)+1 (nstates(k).Lon(l)-milon)+1],[(nstates(k).Lat(l+1)-milat)+1 (nstates(k).Lon(l+1)-milon)+1],[(malat-milat)+1,(malon-milon)+1]);
                mymapstates(ind)=255;
            end
    %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        end
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        for l=1:length(nstates(k).Lat)-1
            if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                ind=sub2ind(size(mymapstates),(nstates(k).Lat(l)-milat)+1, (nstates(k).Lon(l)-milon)+1);
                mymapstates(ind(~isnan(ind)))=255;
            end
        end
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
            if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                [ind, label] = drawline([(nstates(k).Lat(l)-milat)+1 (nstates(k).Lon(l)-milon)+1],[(nstates(k).Lat(l+1)-milat)+1 (nstates(k).Lon(l+1)-milon)+1],[(malat-milat)+1,(malon-milon)+1]);
                mymapstates(ind)=255;
            end
    %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        end
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        for l=1:length(nstates(k).Lat)-1
            if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                ind=sub2ind(size(mymapstates),(nstates(k).Lat(l)-milat)+1, (nstates(k).Lon(l)-milon)+1);
                mymapstates(ind(~isnan(ind)))=255;
            end
        end
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
            if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                [ind, label] = drawline([(nstates(k).Lat(l)-milat)+1 (nstates(k).Lon(l)-milon)+1],[(nstates(k).Lat(l+1)-milat)+1 (nstates(k).Lon(l+1)-milon)+1],[(malat-milat)+1,(malon-milon)+1]);
                mymapstates(ind)=255;
            end
    %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        end
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
        for l=1:length(nstates(k).Lat)-1
            if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                ind=sub2ind(size(mymapstates),(nstates(k).Lat(l)-milat)+1, (nstates(k).Lon(l)-milon)+1);
                mymapstates(ind(~isnan(ind)))=255;
            end
        end
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
                if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                    [ind, label] = drawline([(nstates(k).Lat(l)-milat)+1 (nstates(k).Lon(l)-milon)+1],[(nstates(k).Lat(l+1)-milat)+1 (nstates(k).Lon(l+1)-milon)+1],[(malat-milat)+1,(malon-milon)+1]);
                    mymapstates(ind)=255;
                end
    %         figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
            end
    %     figure(1); imagesc(mymapstates(560:908,764:1573)+double(map8km(560:908,764:1573))); drawnow; pause;
            for l=1:length(nstates(k).Lat)-1
                if (nstates(k).Lat(l)>=milat) && (nstates(k).Lat(l)<=malat) && (nstates(k).Lon(l)>=milon) && (nstates(k).Lon(l)<=malon)
                    ind=sub2ind(size(mymapstates),(nstates(k).Lat(l)-milat)+1, (nstates(k).Lon(l)-milon)+1);
                    mymapstates(ind(~isnan(ind)))=255;
                end
            end
            %plot(nstates(k).Lon,nstates(k).Lat,'.'); hold on; 
        end
    end
    
    eval(['imwrite(uint8(mymapstates),''' cell2mat(namesvar(pp)) '.png'',''png'');']);
    clear mymapstates
end 
