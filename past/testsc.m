function testsc(julianday,thisyear,datapath,modelpath)
pathdata=[datapath '/' thisyear '/'];
prjpath=[modelpath '/'];
% julianday=sprintf('%03d',datenum(date)-datenum('0/0/2012'));
% julianday='270';       
datafiles=dir([pathdata julianday '/']);
for dfs=1:length(datafiles)     % For each 'file':
    if datafiles(dfs).isdir && strcmp(datafiles(dfs).name(1),'A')
        granule=datafiles(dfs).name;
        k=dir([pathdata julianday '/' granule '/*Geo.mat']); l=dir([pathdata julianday '/' granule '/' granule '-1km.jpg']);
        if ~isempty(k) && ~isempty(l)
            fprintf([granule ' ']);        
            load([pathdata julianday '/' granule '/' k.name]);
            GeoFields.Latitude=80060-double(GeoFields.Latitude);
            GeoFields.Longitude=double(GeoFields.Longitude);
            if ~exist('r1km','var')
                if exist([pathdata julianday '/earth-1km.png'],'file')
                    r1km=single(imread([pathdata julianday '/earth-1km.png'],'png')); r1km(r1km(:)==0)=NaN;
                    r2km=single(imread([pathdata julianday '/earth-2km.png'],'png')); r2km(r2km(:)==0)=NaN;
                    r4km=single(imread([pathdata julianday '/earth-4km.png'],'png')); r4km(r4km(:)==0)=NaN;
                    r8km=single(imread([pathdata julianday '/earth-8km.png'],'png')); r8km(r8km(:)==0)=NaN;
                    r16km=single(imread([pathdata julianday '/earth-16km.png'],'png')); r16km(r16km(:)==0)=NaN;
                    r32km=single(imread([pathdata julianday '/earth-32km.png'],'png')); r32km(r32km(:)==0)=NaN;
                    r64km=single(imread([pathdata julianday '/earth-64km.png'],'png')); r64km(r64km(:)==0)=NaN;
                else
                    r1km=single(zeros(20015,40030)).*NaN;
                    r2km=single(zeros(10008,20015)).*NaN;
                    r4km=single(zeros(5004,10008)).*NaN;
                    r8km=single(zeros(2502,5004)).*NaN;
                    r16km=single(zeros(1251,2502)).*NaN;
                    r32km=single(zeros(626,1251)).*NaN;
                    r64km=single(zeros(313,626)).*NaN;
                end
            end
            %500m
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=40031)=40030;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=80061)=80060;
            %1km
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=20016)=20015;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=40031)=40030;                        
            x=single(imread([pathdata julianday '/' granule '/' granule '-1km.jpg']));             
            idx=sub2ind(size(r1km),GeoFields.Latitude(:),GeoFields.Longitude(:)); r1km(idx)=min(r1km(idx),x(:));
            %2km
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=10009)=10008;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=20016)=20015;
            idx=sub2ind(size(r2km),GeoFields.Latitude(:),GeoFields.Longitude(:)); r2km(idx)=min(r2km(idx),x(:));
            %4km
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=5005)=5004;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=10009)=10008;
            idx=sub2ind(size(r4km),GeoFields.Latitude(:),GeoFields.Longitude(:)); r4km(idx)=min(r4km(idx),x(:));
            %8km
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=2503)=2502;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=5005)=5004;
            idx=sub2ind(size(r8km),GeoFields.Latitude(:),GeoFields.Longitude(:)); r8km(idx)=min(r8km(idx),x(:));
            %16km
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=1252)=1251;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=2503)=2502;
            idx=sub2ind(size(r16km),GeoFields.Latitude(:),GeoFields.Longitude(:)); r16km(idx)=min(r16km(idx),x(:));
            %32km
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=627)=626;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=1252)=1251;
            idx=sub2ind(size(r32km),GeoFields.Latitude(:),GeoFields.Longitude(:)); r32km(idx)=min(r32km(idx),x(:));
            %64km
            GeoFields.Latitude=round(GeoFields.Latitude./2); GeoFields.Latitude(GeoFields.Latitude(:)<=0)=1; GeoFields.Latitude(GeoFields.Latitude(:)>=314)=313;
            GeoFields.Longitude=round(GeoFields.Longitude./2); GeoFields.Longitude(GeoFields.Longitude(:)<=0)=1; GeoFields.Longitude(GeoFields.Longitude(:)>=627)=626;
            idx=sub2ind(size(r64km),GeoFields.Latitude(:),GeoFields.Longitude(:)); r64km(idx)=min(r64km(idx),x(:));
            delete([pathdata julianday '/' granule '/*Geo.mat']);         
        end        
    end
end
if exist('r1km','var')
    fprintf('writing jpegs...');
    load([prjpath 'maps.mat']);
    r1km=uint8(uint8(r1km)+uint8(map1km));
    r2km=uint8(uint8(r2km)+uint8(map2km));
    r4km=uint8(uint8(r4km)+uint8(map4km));
    r8km=uint8(uint8(r8km)+uint8(map8km));
    r16km=uint8(uint8(r16km)+uint8(map16km));
    r32km=uint8(uint8(r32km)+uint8(map32km));
    r64km=uint8(uint8(r64km)+uint8(map64km));
    imwrite(r1km,[pathdata julianday '/earth-1km.png'],'png'); clear r1km;
    imwrite(r2km,[pathdata julianday '/earth-2km.png'],'png'); clear r2km;
    imwrite(r4km,[pathdata julianday '/earth-4km.png'],'png'); clear r4km;
    imwrite(r8km,[pathdata julianday '/earth-8km.png'],'png'); clear r8km;
    imwrite(r16km,[pathdata julianday '/earth-16km.png'],'png'); clear r16km;
    imwrite(r32km,[pathdata julianday '/earth-32km.png'],'png'); clear r32km;
    imwrite(r64km,[pathdata julianday '/earth-64km.png'],'png'); clear r64km;
end
clear all;
fprintf(' done\n');
quit;
end
