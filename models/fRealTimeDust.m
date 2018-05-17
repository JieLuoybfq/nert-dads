%=========================================================================
% Author:       Pablo Rivas Perea
% Afiilliation: The University of Texas El Paso
% Developed at: Home
%               
% Date:         Spring 2012
% Description:  This function explores current directory to find all basic
%               granueles necesary for multispectral analysis.  It extracts
%               data, interpolate if necessary, and saves the multispectral
%               corrected data into matlab format.
% Updates:  
%               
%=========================================================================

function [ptime]=fRealTimeDust(granulesdir,classifiersdir)
    tic; %initializes the counter of time

    load([classifiersdir 'rgbfit.mat'])
    % the time of exponential function used is of the type 'exp2'

    prp=0;  %this counter is for?
    sat='terra';
    filedirectory=granulesdir; cd(filedirectory); j=dir('MOD021KM*.hdf'); 
    if isempty(j); fprintf(' 1km data missing...'); end;
    for k=1:size(j,1)        
        fnameb8tob36=j(k).name; fname=j(k).name; 
        fprintf([' reading HDF files for: ' fname(10:22) '\n']);   
        filetofind=['MOD03' fname(9:22) '*.hdf']; l=dir(filetofind);
        if isempty(l); fprintf(' Geolocation data missing...'); end;
        if ~isempty(l) 
            fnameGeoFields=l(1).name; 

            prp=prp+1;
            %extract band 1,3,4,20,29,31,32 data and uncertainty index
            %at 1km resolution.  Geofields are also extracted at 1km
            %resolution.
            %======= Band 1===================================
            inffile=hdfinfo(fnameb8tob36);
%             Band1to2Imgs=hdfread(fnameb8tob36, 'MODIS_SWATH_Type_L1B', 'Fields', 'EV_250_Aggr1km_RefSB');
%             B1=double(reshape(Band1to2Imgs(1,:,:),size(Band1to2Imgs,2),size(Band1to2Imgs,3)));
%             clear Band1to2Imgs Band1to2ImUI                
%             fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(5).Attributes(4).Value);
%             [B1]=pfInterpFillValues(B1,fillvalue,40);
%             %correct (recover) band
%             reflectance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,5).Attributes(1,9).Value(1));
%             reflectance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,5).Attributes(1,10).Value(1));                
%             coB1=(B1-reflectance_offset).*reflectance_scale;
%             bmin=-0.01; bmax=1.10;
%             coB1=((coB1-bmin)./(bmax-bmin)).*255;
%             coB1=reshape(redfitcorr(coB1),size(coB1));  %performing fit for visual correction
%             clear Band1to2Imgs Band1to2ImUI ui_scale spec_uncert reflectance_scale reflectance_offset fillvalue fillvalueUI bmax bmin
%             %======Band 3========================================
%             Band3to7Imgs=hdfread(fnameb8tob36, 'MODIS_SWATH_Type_L1B', 'Fields', 'EV_500_Aggr1km_RefSB');
%             B3=double(reshape(Band3to7Imgs(1,:,:),size(Band3to7Imgs,2),size(Band3to7Imgs,3)));
%             fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(8).Attributes(4).Value);
%             [B3]=pfInterpFillValues(B3,fillvalue,40);
%             %correct (recover) band
%             reflectance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,8).Attributes(1,9).Value(1));
%             reflectance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,8).Attributes(1,10).Value(1));                
%             coB3=(B3-reflectance_offset).*reflectance_scale;
%             bmin=-0.01; bmax=1.10;
%             coB3=((coB3-bmin)./(bmax-bmin)).*255;
%             coB3=reshape(bluefitcorr(coB3),size(coB3));  %performing fit for visual correction
%             %========Band 4 =====================================
%             B4=double(reshape(Band3to7Imgs(2,:,:),size(Band3to7Imgs,2),size(Band3to7Imgs,3)));
%             fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(8).Attributes(4).Value);
%             [B4]=pfInterpFillValues(B4,fillvalue,40);
%             %correct (recover) band
%             reflectance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,8).Attributes(1,9).Value(2));
%             reflectance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,8).Attributes(1,10).Value(2));                
%             coB4=(B4-reflectance_offset).*reflectance_scale;
%             bmin=-0.01; bmax=1.10;
%             coB4=((coB4-bmin)./(bmax-bmin)).*255;
%             coB4=reshape(greenfitcorr(coB4),size(coB4));  %performing fit for visual correction
%             clear Band3to7Imgs Band3to7ImUI ui_scale spec_uncert reflectance_scale reflectance_offset fillvalue fillvalueUI bmax bmin
            %==========Band 20====================================
            Band8to36Imgs=hdfread(fnameb8tob36, 'MODIS_SWATH_Type_L1B', 'Fields', 'EV_1KM_Emissive');
            Band8to36ImUI=hdfread(fnameb8tob36, 'MODIS_SWATH_Type_L1B', 'Fields', 'EV_1KM_Emissive_Uncert_Indexes');
%             B20=double(reshape(Band8to36Imgs(1,:,:),size(Band8to36Imgs,2),size(Band8to36Imgs,3)));
%             uiB20=double(reshape(Band8to36ImUI(1,:,:),size(Band8to36ImUI,2),size(Band8to36ImUI,3)));
%             fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(3).Attributes(4).Value);
%             fillvalueUI=double(inffile.Vgroup.Vgroup(2).SDS(4).Attributes(4).Value);
%             [B20]=pfInterpFillValues(B20,fillvalue,40);
%             [uiB20]=pfInterpFillValues(uiB20,fillvalueUI,40);                                    
%             suiB=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(5).Value(1);
%             ellBn=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(6).Value(1);
%             %correct (recover) band
%             radiance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,6).Value(1));
%             radiance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,7).Value(1));                
%             coB20=(B20-radiance_offset).*radiance_scale;
%             [B20]=fApproximateTrueBand(double(B20),suiB,double(uiB20),ellBn);
%             %==========Band 29===================================
%             B29=double(reshape(Band8to36Imgs(9,:,:),size(Band8to36Imgs,2),size(Band8to36Imgs,3)));
%             uiB29=double(reshape(Band8to36ImUI(9,:,:),size(Band8to36ImUI,2),size(Band8to36ImUI,3)));
%             fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(3).Attributes(4).Value);
%             fillvalueUI=double(inffile.Vgroup.Vgroup(2).SDS(4).Attributes(4).Value);
%             [B29]=pfInterpFillValues(B29,fillvalue,40);
%             [uiB29]=pfInterpFillValues(uiB29,fillvalueUI,40);                                    
%             suiB=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(5).Value(9);
%             ellBn=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(6).Value(9);
%             %correct (recover) band
%             radiance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,6).Value(9));
%             radiance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,7).Value(9));                
%             coB29=(B29-radiance_offset).*radiance_scale;
%             [B29]=fApproximateTrueBand(double(B29),suiB,double(uiB29),ellBn);
%             %==========Band 30===================================
%             B30=double(reshape(Band8to36Imgs(10,:,:),size(Band8to36Imgs,2),size(Band8to36Imgs,3)));
%             uiB30=double(reshape(Band8to36ImUI(10,:,:),size(Band8to36ImUI,2),size(Band8to36ImUI,3)));
%             fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(3).Attributes(4).Value);
%             fillvalueUI=double(inffile.Vgroup.Vgroup(2).SDS(4).Attributes(4).Value);
%             [B30]=pfInterpFillValues(B30,fillvalue,40);
%             [uiB30]=pfInterpFillValues(uiB30,fillvalueUI,40);                                    
%             suiB=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(5).Value(10);
%             ellBn=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(6).Value(10);
%             %correct (recover) band
%             radiance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,6).Value(10));
%             radiance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,7).Value(10));                
%             coB30=(B30-radiance_offset).*radiance_scale;
%             [B30]=fApproximateTrueBand(double(B30),suiB,double(uiB30),ellBn);
            %==========Band 31===================================                
            B31=double(reshape(Band8to36Imgs(11,:,:),size(Band8to36Imgs,2),size(Band8to36Imgs,3)));
            uiB31=double(reshape(Band8to36ImUI(11,:,:),size(Band8to36ImUI,2),size(Band8to36ImUI,3)));
            fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(3).Attributes(4).Value);
            fillvalueUI=double(inffile.Vgroup.Vgroup(2).SDS(4).Attributes(4).Value);
            [B31]=pfInterpFillValues(B31,fillvalue,40);
            [uiB31]=pfInterpFillValues(uiB31,fillvalueUI,40);                                    
            suiB=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(5).Value(11);
            ellBn=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(6).Value(11);
            %correct (recover) band
            radiance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,6).Value(11));
            radiance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,7).Value(11));                
            coB31=(B31-radiance_offset).*radiance_scale;
            [B31]=fApproximateTrueBand(double(B31),suiB,double(uiB31),ellBn);
            %==========Band 32===================================                                
            B32=double(reshape(Band8to36Imgs(12,:,:),size(Band8to36Imgs,2),size(Band8to36Imgs,3)));
            uiB32=double(reshape(Band8to36ImUI(12,:,:),size(Band8to36ImUI,2),size(Band8to36ImUI,3)));                    
            fillvalue=double(inffile.Vgroup.Vgroup(2).SDS(3).Attributes(4).Value);
            fillvalueUI=double(inffile.Vgroup.Vgroup(2).SDS(4).Attributes(4).Value);
            [B32]=pfInterpFillValues(B32,fillvalue,40);
            [uiB32]=pfInterpFillValues(uiB32,fillvalueUI,40);                                    
            suiB=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(5).Value(12);
            ellBn=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(6).Value(12);
            %correct (recover) band
            radiance_scale=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,6).Value(12));
            radiance_offset=double(inffile.Vgroup.Vgroup(1,2).SDS(1,3).Attributes(1,7).Value(12));                
            coB32=(B32-radiance_offset).*radiance_scale;
            [B32]=fApproximateTrueBand(double(B32),suiB,double(uiB32),ellBn);
            clear Band8to36Imgs Band8to36ImUI ui_scale spec_uncert reflectance_scale reflectance_offset fillvalue fillvalueUI bmax bmin suiB ellBn
            %==========Geolocation Fields=============================                                                
            Latitude =double(hdfread(fnameGeoFields, 'MODIS_Swath_Type_GEO', 'Fields', 'Latitude'));                
            fillvalue=double(inffile.Vgroup.Vgroup(1).SDS(1).Attributes(3).Value);
            [Latitude]=pfInterpFillValues(Latitude,fillvalue,40);
            Longitude =double(hdfread(fnameGeoFields, 'MODIS_Swath_Type_GEO', 'Fields', 'Longitude'));                
            fillvalue=double(inffile.Vgroup.Vgroup(1).SDS(2).Attributes(3).Value);
            [Longitude]=pfInterpFillValues(Longitude,fillvalue,40);   
            GeoFields=struct('Latitude',uint32(round(((Latitude+90).*444.77777)+1)), 'Longitude',uint32(round(((Longitude+180).*444.77777)+1)));
            matfname1km=[filedirectory '/' num2str(fnameb8tob36(10:22)) '.Geo.mat'];                
            save(matfname1km, 'GeoFields'); clear GeoFields matfname1km;
            
            %generating structures to save data to disk
            GeoFields=struct('Latitude',Latitude, 'Longitude',Longitude);
            clear Latitude Longitude
%             B1=struct('ioi',B1,'icoi',coB1); clear uiB1 couiB1 coB1
%             B3=struct('ioi',B3,'icoi',coB3); clear uiB3 couiB3 coB3
%             B4=struct('ioi',B4,'icoi',coB4); clear uiB4 couiB4 coB4
%             B20=struct('ioi',B20,'icoi',coB20); clear uiB20 couiB20 coB20
%             B29=struct('ioi',B29,'icoi',coB29); clear uiB29 couiB29 coB29
%             B30=struct('ioi',B30,'icoi',coB30); clear uiB30 couiB30 coB30
            B31=struct('ioi',B31,'icoi',coB31); clear uiB31 couiB31 coB31
            B32=struct('ioi',B32,'icoi',coB32); clear uiB32 couiB32 coB32

            clear fillvalue radiance_offset radiance_scale filetofind fname
            matfname1km=[filedirectory '/' num2str(fnameb8tob36(10:22)) '.1km.mat'];                
            save(matfname1km, 'B31', 'B32', 'GeoFields'); clear AOT B20 B29 B30 B31 B32;
%             [R]=pfMercatorReprojectData(B1.icoi, GeoFields.Latitude, GeoFields.Longitude,'1km');
%             [G]=pfMercatorReprojectData(B4.icoi, GeoFields.Latitude, GeoFields.Longitude,'1km');
%             [B]=pfMercatorReprojectData(B3.icoi, GeoFields.Latitude, GeoFields.Longitude,'1km');
%             ColorImg=uint8(round(cat(3,R,G,B))); clear GeoFields
%             imwrite(ColorImg,[filedirectory '/tc1km-r.jpg'],'jpg'); clear ColorImg R G B
%             ColorImg=uint8(round(cat(3, B1.icoi, B4.icoi, B3.icoi))); clear B1 B3 B4 
%             imwrite(ColorImg,[filedirectory '/tc1km.jpg'],'jpg'); clear ColorImg

            load(matfname1km, 'B31', 'B32', 'GeoFields'); 
            fpaperDetectDustRaw(B31.ioi,B32.ioi,classifiersdir); clear B20 B29 B31 B32;

            ReprojectAndSave('PDres', GeoFields.Latitude, GeoFields.Longitude, '1km', filedirectory, [fnameb8tob36(10:17) fnameb8tob36(19:22)]);
%             ReprojectAndSave('x', GeoFields.Latitude, GeoFields.Longitude, '1km', filedirectory);
            clear GeoFields

%             load(matfname1km, 'B1', 'B3', 'B4', 'GeoFields'); 
%             load([classifiersdir 'rgb8bitpic.mat'])
%             rgb=cat(3,B1.icoi,B4.icoi,B3.icoi); clear B1 B3 B4;
%             load('tmpclass.mat','y','rate'); 
%             rate=single(rate)./255;
%             res1=(double(rgb(:,:,1)).*(1-rate))+(double(y(:,:,1)).*(rate));
%             res2=(double(rgb(:,:,2)).*(1-rate))+(double(y(:,:,2)).*(rate));
%             res3=(double(rgb(:,:,3)).*(1-rate))+(double(y(:,:,3)).*(rate)); clear y rate mask rgb
%             ColorImg=uint8(round(cat(3, res1, res2, res3))); 
%             imwrite(ColorImg,[filedirectory '/tcres1km.jpg'],'jpg'); clear ColorImg
%             [R]=pfMercatorReprojectData(res1, GeoFields.Latitude, GeoFields.Longitude,'1km'); clear res1;
%             [G]=pfMercatorReprojectData(res2, GeoFields.Latitude, GeoFields.Longitude,'1km'); clear res2;
%             [B]=pfMercatorReprojectData(res3, GeoFields.Latitude, GeoFields.Longitude,'1km'); clear res3;
%             ColorImg=uint8(round(cat(3,R,G,B))); clear GeoFields R G B
%             imwrite(ColorImg,[filedirectory '/tcres1km-r.jpg'],'jpg'); clear ColorImg 



            fprintf(' Finished 1km data.');
            delete(matfname1km);
            delete([granulesdir '/tmpclass.mat']);
            %delete([granulesdir '/*.hdf']);

        end 
    end           
    ptime=toc; %gives the total processing time
end


function [InterBand]=pfInterpFillValues(Band,FillValue,BlockSize)
    if sum(Band(:)==FillValue)>0
        Band(Band==FillValue)=NaN;
        maxrows=size(Band,1);
        for row=1:BlockSize:maxrows-BlockSize
            if (sum(sum(isnan(Band(row:row+(BlockSize-1),:))))>0) 
                tband=inpaint_nans(Band(row:row+(BlockSize-1),:));
            else
                tband=Band(row:row+(BlockSize-1),:);
            end
            if row==1
                rband=tband;
            else
                rband=cat(1,rband,tband);
            end
        end
        if (sum(sum(isnan(Band(row+BlockSize:maxrows,:))))>0) 
            tband=inpaint_nans(Band(row+BlockSize:maxrows,:));
        else
            tband=Band(row+BlockSize:maxrows,:);
        end
        rband=cat(1,rband,tband);
        InterBand=rband; clear rband band    
    else
        InterBand=Band; 
    end            

end


function B=inpaint_nans(A,method)
    % INPAINT_NANS: in-paints over nans in an array
    % usage: B=INPAINT_NANS(A)          % default method
    % usage: B=INPAINT_NANS(A,method)   % specify method used
    %
    % Solves approximation to one of several pdes to
    % interpolate and extrapolate holes in an array
    %
    % arguments (input):
    %   A - nxm array with some NaNs to be filled in
    %
    %   method - (OPTIONAL) scalar numeric flag - specifies
    %       which approach (or physical metaphor to use
    %       for the interpolation.) All methods are capable
    %       of extrapolation, some are better than others.
    %       There are also speed differences, as well as
    %       accuracy differences for smooth surfaces.
    %
    %       methods {0,1,2} use a simple plate metaphor.
    %       method  3 uses a better plate equation,
    %                 but may be much slower and uses
    %                 more memory.
    %       method  4 uses a spring metaphor.
    %       method  5 is an 8 neighbor average, with no
    %                 rationale behind it compared to the
    %                 other methods. I do not recommend
    %                 its use.
    %
    %       method == 0 --> (DEFAULT) see method 1, but
    %         this method does not build as large of a
    %         linear system in the case of only a few
    %         NaNs in a large array.
    %         Extrapolation behavior is linear.
    %         
    %       method == 1 --> simple approach, applies del^2
    %         over the entire array, then drops those parts
    %         of the array which do not have any contact with
    %         NaNs. Uses a least squares approach, but it
    %         does not modify known values.
    %         In the case of small arrays, this method is
    %         quite fast as it does very little extra work.
    %         Extrapolation behavior is linear.
    %         
    %       method == 2 --> uses del^2, but solving a direct
    %         linear system of equations for nan elements.
    %         This method will be the fastest possible for
    %         large systems since it uses the sparsest
    %         possible system of equations. Not a least
    %         squares approach, so it may be least robust
    %         to noise on the boundaries of any holes.
    %         This method will also be least able to
    %         interpolate accurately for smooth surfaces.
    %         Extrapolation behavior is linear.
    %         
    %       method == 3 --+ See method 0, but uses del^4 for
    %         the interpolating operator. This may result
    %         in more accurate interpolations, at some cost
    %         in speed.
    %         
    %       method == 4 --+ Uses a spring metaphor. Assumes
    %         springs (with a nominal length of zero)
    %         connect each node with every neighbor
    %         (horizontally, vertically and diagonally)
    %         Since each node tries to be like its neighbors,
    %         extrapolation is as a constant function where
    %         this is consistent with the neighboring nodes.
    %
    %       method == 5 --+ See method 2, but use an average
    %         of the 8 nearest neighbors to any element.
    %         This method is NOT recommended for use.
    %
    %
    % arguments (output):
    %   B - nxm array with NaNs replaced
    %
    %
    % Example:
    %  [x,y] = meshgrid(0:.01:1);
    %  z0 = exp(x+y);
    %  znan = z0;
    %  znan(20:50,40:70) = NaN;
    %  znan(30:90,5:10) = NaN;
    %  znan(70:75,40:90) = NaN;
    %
    %  z = inpaint_nans(znan);
    %
    %
    % See also: griddata, interp1
    %
    % Author: John D'Errico
    % e-mail address: woodchips@rochester.rr.com
    % Release: 2
    % Release date: 4/15/06


    % I always need to know which elements are NaN,
    % and what size the array is for any method
    [n,m]=size(A);
    A=A(:);
    nm=n*m;
    k=isnan(A(:));

    % list the nodes which are known, and which will
    % be interpolated
    nan_list=find(k);
    known_list=find(~k);

    % how many nans overall
    nan_count=length(nan_list);

    % convert NaN indices to (r,c) form
    % nan_list==find(k) are the unrolled (linear) indices
    % (row,column) form
    [nr,nc]=ind2sub([n,m],nan_list);

    % both forms of index in one array:
    % column 1 == unrolled index
    % column 2 == row index
    % column 3 == column index
    nan_list=[nan_list,nr,nc];

    % supply default method
    if (nargin<2) || isempty(method)
      method = 0;
    elseif ~ismember(method,0:5)
      error 'If supplied, method must be one of: {0,1,2,3,4,5}.'
    end

    % for different methods
    switch method
     case 0
      % The same as method == 1, except only work on those
      % elements which are NaN, or at least touch a NaN.

      % horizontal and vertical neighbors only
      talks_to = [-1 0;0 -1;1 0;0 1];
      neighbors_list=identify_neighbors(n,m,nan_list,talks_to);

      % list of all nodes we have identified
      all_list=[nan_list;neighbors_list];

      % generate sparse array with second partials on row
      % variable for each element in either list, but only
      % for those nodes which have a row index > 1 or < n
      L = find((all_list(:,2) > 1) & (all_list(:,2) < n)); 
      nl=length(L);
      if nl>0
        fda=sparse(repmat(all_list(L,1),1,3), ...
          repmat(all_list(L,1),1,3)+repmat([-1 0 1],nl,1), ...
          repmat([1 -2 1],nl,1),nm,nm);
      else
        fda=spalloc(n*m,n*m,size(all_list,1)*5);
      end

      % 2nd partials on column index
      L = find((all_list(:,3) > 1) & (all_list(:,3) < m)); 
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(all_list(L,1),1,3), ...
          repmat(all_list(L,1),1,3)+repmat([-n 0 n],nl,1), ...
          repmat([1 -2 1],nl,1),nm,nm);
      end

      % eliminate knowns
      rhs=-fda(:,known_list)*A(known_list);
      k=find(any(fda(:,nan_list(:,1)),2));

      % and solve...
      B=A;
      B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);

     case 1
      % least squares approach with del^2. Build system
      % for every array element as an unknown, and then
      % eliminate those which are knowns.

      % Build sparse matrix approximating del^2 for
      % every element in A.
      % Compute finite difference for second partials
      % on row variable first
      [i,j]=ndgrid(2:(n-1),1:m);
      ind=i(:)+(j(:)-1)*n;
      np=(n-2)*m;
      fda=sparse(repmat(ind,1,3),[ind-1,ind,ind+1], ...
          repmat([1 -2 1],np,1),n*m,n*m);

      % now second partials on column variable
      [i,j]=ndgrid(1:n,2:(m-1));
      ind=i(:)+(j(:)-1)*n;
      np=n*(m-2);
      fda=fda+sparse(repmat(ind,1,3),[ind-n,ind,ind+n], ...
          repmat([1 -2 1],np,1),nm,nm);

      % eliminate knowns
      rhs=-fda(:,known_list)*A(known_list);
      k=find(any(fda(:,nan_list),2));

      % and solve...
      B=A;
      B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);

     case 2
      % Direct solve for del^2 BVP across holes

      % generate sparse array with second partials on row
      % variable for each nan element, only for those nodes
      % which have a row index > 1 or < n
      L = find((nan_list(:,2) > 1) & (nan_list(:,2) < n)); 
      nl=length(L);
      if nl>0
        fda=sparse(repmat(nan_list(L,1),1,3), ...
          repmat(nan_list(L,1),1,3)+repmat([-1 0 1],nl,1), ...
          repmat([1 -2 1],nl,1),n*m,n*m);
      else
        fda=spalloc(n*m,n*m,size(nan_list,1)*5);
      end

      % 2nd partials on column index
      L = find((nan_list(:,3) > 1) & (nan_list(:,3) < m)); 
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,3), ...
          repmat(nan_list(L,1),1,3)+repmat([-n 0 n],nl,1), ...
          repmat([1 -2 1],nl,1),n*m,n*m);
      end

      % fix boundary conditions at extreme corners
      % of the array in case there were nans there
      if ismember(1,nan_list(:,1))
        fda(1,[1 2 n+1])=[-2 1 1];
      end
      if ismember(n,nan_list(:,1))
        fda(n,[n, n-1,n+n])=[-2 1 1];
      end
      if ismember(nm-n+1,nan_list(:,1))
        fda(nm-n+1,[nm-n+1,nm-n+2,nm-n])=[-2 1 1];
      end
      if ismember(nm,nan_list(:,1))
        fda(nm,[nm,nm-1,nm-n])=[-2 1 1];
      end

      % eliminate knowns
      rhs=-fda(:,known_list)*A(known_list);

      % and solve...
      B=A;
      k=nan_list(:,1);
      B(k)=fda(k,k)\rhs(k);

     case 3
      % The same as method == 0, except uses del^4 as the
      % interpolating operator.

      % del^4 template of neighbors
      talks_to = [-2 0;-1 -1;-1 0;-1 1;0 -2;0 -1; ...
          0 1;0 2;1 -1;1 0;1 1;2 0];
      neighbors_list=identify_neighbors(n,m,nan_list,talks_to);

      % list of all nodes we have identified
      all_list=[nan_list;neighbors_list];

      % generate sparse array with del^4, but only
      % for those nodes which have a row & column index
      % >= 3 or <= n-2
      L = find( (all_list(:,2) >= 3) & ...
                (all_list(:,2) <= (n-2)) & ...
                (all_list(:,3) >= 3) & ...
                (all_list(:,3) <= (m-2)));
      nl=length(L);
      if nl>0
        % do the entire template at once
        fda=sparse(repmat(all_list(L,1),1,13), ...
            repmat(all_list(L,1),1,13) + ...
            repmat([-2*n,-n-1,-n,-n+1,-2,-1,0,1,2,n-1,n,n+1,2*n],nl,1), ...
            repmat([1 2 -8 2 1 -8 20 -8 1 2 -8 2 1],nl,1),nm,nm);
      else
        fda=spalloc(n*m,n*m,size(all_list,1)*5);
      end

      % on the boundaries, reduce the order around the edges
      L = find((((all_list(:,2) == 2) | ...
                 (all_list(:,2) == (n-1))) & ...
                (all_list(:,3) >= 2) & ...
                (all_list(:,3) <= (m-1))) | ...
               (((all_list(:,3) == 2) | ...
                 (all_list(:,3) == (m-1))) & ...
                (all_list(:,2) >= 2) & ...
                (all_list(:,2) <= (n-1))));
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(all_list(L,1),1,5), ...
          repmat(all_list(L,1),1,5) + ...
            repmat([-n,-1,0,+1,n],nl,1), ...
          repmat([1 1 -4 1 1],nl,1),nm,nm);
      end

      L = find( ((all_list(:,2) == 1) | ...
                 (all_list(:,2) == n)) & ...
                (all_list(:,3) >= 2) & ...
                (all_list(:,3) <= (m-1)));
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(all_list(L,1),1,3), ...
          repmat(all_list(L,1),1,3) + ...
            repmat([-n,0,n],nl,1), ...
          repmat([1 -2 1],nl,1),nm,nm);
      end

      L = find( ((all_list(:,3) == 1) | ...
                 (all_list(:,3) == m)) & ...
                (all_list(:,2) >= 2) & ...
                (all_list(:,2) <= (n-1)));
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(all_list(L,1),1,3), ...
          repmat(all_list(L,1),1,3) + ...
            repmat([-1,0,1],nl,1), ...
          repmat([1 -2 1],nl,1),nm,nm);
      end

      % eliminate knowns
      rhs=-fda(:,known_list)*A(known_list);
      k=find(any(fda(:,nan_list(:,1)),2));

      % and solve...
      B=A;
      B(nan_list(:,1))=fda(k,nan_list(:,1))\rhs(k);

     case 4
      % Spring analogy
      % interpolating operator.

      % list of all springs between a node and a horizontal
      % or vertical neighbor
      hv_list=[-1 -1 0;1 1 0;-n 0 -1;n 0 1];
      hv_springs=[];
      for i=1:4
        hvs=nan_list+repmat(hv_list(i,:),nan_count,1);
        k=(hvs(:,2)>=1) & (hvs(:,2)<=n) & (hvs(:,3)>=1) & (hvs(:,3)<=m);
        hv_springs=[hv_springs;[nan_list(k,1),hvs(k,1)]];
      end

      % delete replicate springs
      hv_springs=unique(sort(hv_springs,2),'rows');

      % build sparse matrix of connections, springs
      % connecting diagonal neighbors are weaker than
      % the horizontal and vertical springs
      nhv=size(hv_springs,1);
      springs=sparse(repmat((1:nhv)',1,2),hv_springs, ...
         repmat([1 -1],nhv,1),nhv,nm);

      % eliminate knowns
      rhs=-springs(:,known_list)*A(known_list);

      % and solve...
      B=A;
      B(nan_list(:,1))=springs(:,nan_list(:,1))\rhs;

     case 5
      % Average of 8 nearest neighbors

      % generate sparse array to average 8 nearest neighbors
      % for each nan element, be careful around edges
      fda=spalloc(n*m,n*m,size(nan_list,1)*9);

      % -1,-1
      L = find((nan_list(:,2) > 1) & (nan_list(:,3) > 1)); 
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([-n-1, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % 0,-1
      L = find(nan_list(:,3) > 1);
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([-n, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % +1,-1
      L = find((nan_list(:,2) < n) & (nan_list(:,3) > 1));
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([-n+1, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % -1,0
      L = find(nan_list(:,2) > 1);
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([-1, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % +1,0
      L = find(nan_list(:,2) < n);
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([1, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % -1,+1
      L = find((nan_list(:,2) > 1) & (nan_list(:,3) < m)); 
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([n-1, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % 0,+1
      L = find(nan_list(:,3) < m);
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([n, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % +1,+1
      L = find((nan_list(:,2) < n) & (nan_list(:,3) < m));
      nl=length(L);
      if nl>0
        fda=fda+sparse(repmat(nan_list(L,1),1,2), ...
          repmat(nan_list(L,1),1,2)+repmat([n+1, 0],nl,1), ...
          repmat([1 -1],nl,1),n*m,n*m);
      end

      % eliminate knowns
      rhs=-fda(:,known_list)*A(known_list);

      % and solve...
      B=A;
      k=nan_list(:,1);
      B(k)=fda(k,k)\rhs(k);

    end

    % all done, make sure that B is the same shape as
    % A was when we came in.
    B=reshape(B,n,m);


    % ====================================================
    %      end of main function
    % ====================================================
end

% ====================================================
%      begin subfunctions
% ====================================================
function neighbors_list=identify_neighbors(n,m,nan_list,talks_to)
    % identify_neighbors: identifies all the neighbors of
    %   those nodes in nan_list, not including the nans
    %   themselves
    %
    % arguments (input):
    %  n,m - scalar - [n,m]=size(A), where A is the
    %      array to be interpolated
    %  nan_list - array - list of every nan element in A
    %      nan_list(i,1) == linear index of i'th nan element
    %      nan_list(i,2) == row index of i'th nan element
    %      nan_list(i,3) == column index of i'th nan element
    %  talks_to - px2 array - defines which nodes communicate
    %      with each other, i.e., which nodes are neighbors.
    %
    %      talks_to(i,1) - defines the offset in the row
    %                      dimension of a neighbor
    %      talks_to(i,2) - defines the offset in the column
    %                      dimension of a neighbor
    %      
    %      For example, talks_to = [-1 0;0 -1;1 0;0 1]
    %      means that each node talks only to its immediate
    %      neighbors horizontally and vertically.
    % 
    % arguments(output):
    %  neighbors_list - array - list of all neighbors of
    %      all the nodes in nan_list

    if ~isempty(nan_list)
      % use the definition of a neighbor in talks_to
      nan_count=size(nan_list,1);
      talk_count=size(talks_to,1);

      nn=zeros(nan_count*talk_count,2);
      j=[1,nan_count];
      for i=1:talk_count
        nn(j(1):j(2),:)=nan_list(:,2:3) + ...
            repmat(talks_to(i,:),nan_count,1);
        j=j+nan_count;
      end

      % drop those nodes which fall outside the bounds of the
      % original array
      L = (nn(:,1)<1)|(nn(:,1)>n)|(nn(:,2)<1)|(nn(:,2)>m); 
      nn(L,:)=[];

      % form the same format 3 column array as nan_list
      neighbors_list=[sub2ind([n,m],nn(:,1),nn(:,2)),nn];

      % delete replicates in the neighbors list
      neighbors_list=unique(neighbors_list,'rows');

      % and delete those which are also in the list of NaNs.
      neighbors_list=setdiff(neighbors_list,nan_list,'rows');

    else
      neighbors_list=[];
    end
end


function NormScaledImg=fpaperNormScaleImg(ImgData)
    minval=min(ImgData(:));
    ImgData=ImgData-minval;
    maxval=max(ImgData(:));
    NormScaledImg=ImgData./maxval;    
end


function [ReprojData]=pfMercatorReprojectData(Data,Latitude,Longitude,Resol)
    switch Resol
        case '1km'
            Resol=100;
        case 'hkm'
            Resol=200;
        case 'qkm'
            Resol=400;
    end
    maxlat=max(Latitude(:));
    minlat=min(Latitude(:));
    maxlon=max(Longitude(:));
    minlon=min(Longitude(:));
    tcsize=[round(maxlat*Resol)-round(minlat*Resol)+1,round(maxlon*Resol)-round(minlon*Resol)+1];
    while prod(tcsize)>50e6        
        Resol=round(Resol.*0.1);
        tcsize=[round(maxlat*Resol)-round(minlat*Resol)+1,round(maxlon*Resol)-round(minlon*Resol)+1];
    end
    tc=(ones(tcsize)).*NaN;
    minla=round(minlat*Resol);
    minlo=round(minlon*Resol);

    for r=1:size(Latitude,1)
        for c=1:size(Latitude,2)
            ro=round(Latitude(r,c)*Resol)-minla+1;
            co=round(Longitude(r,c)*Resol)-minlo+1;
            tc(tcsize(1)-(ro-1),co)=Data(r,c);            
        end
    end
    
    clear Longitude Latitude Data

    maxrows=size(tc,1);    
    for row=1:maxrows
        c=find(tc(row,:)>0);
        if isempty(c)
            c1=1; c2=1;
        else
            c1=c(1); c2=c(size(c,2));
        end
        tc(row,1:c1)=0;
        tc(row,c2+1:size(tc,2))=0;
    end
    tic
    
    for row=1:50:maxrows-50
        jct=uint8(round(inpaint_nans(tc(row:row+49,:),2)));
        if row==1
            jc=jct;
        else
            jc=cat(1,jc,jct);
        end
    end
    jct=uint8(round(inpaint_nans(tc(row+50:maxrows,:),2)));
    ReprojData=cat(1,jc,jct);
    clear tc jct
    
    
end



function [rband]=fApproximateTrueBand(band,suiB,UIBn,ellBn)
    % Example
    % clear all; close all; clc;
    % load('C:\HDF\DS\A2002183.1755\A2002183.1755.mat','modis');
    % inffile=hdfinfo('C:\HDF\DS\A2002183.1755\MOD021KM.A2002183.1755.005.2008238052433.hdf');
    % band=double(modis.B20.Img);
    % suiB=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(5).Value(1);
    % UIBn=double(modis.B20.UI);
    % ellBn=inffile.Vgroup.Vgroup(2).SDS(4).Attributes(6).Value(1);
    % tic
    % [rband]=fApproximateTrueBand(band,suiB,UIBn,ellBn);
    % toc

    %% Determine parameters
    % uiBn -> Unncertainty Index in percent
    % ciBn -> rational Certainty Index 
    uiBn=(suiB.*exp(UIBn./ellBn));
    ciBn=1-(uiBn./100);
    omax=max(max(band(band<2^15)));
    omin=min(band(:));
    % if all is unusable omax will be empty, this is a fix for that, added
    % on Mar/1/2016 prp
    if isempty(omax)
        omax = omin+1;
    end

    %% Uncertainty based in saturation
    % All pixels having a value of/or greater than 2^15 = 32768
    %
    % What we do is a decimation of 10 and median filtering [3,3] and then an
    % upsampling of a factor of 10 and replace the values obtained by the
    % decimation into exactly the piexels with unusable information

    [rowsize,colsize]=size(band);           %get the original size
    mband=band;
    maskofunusablepix=mband>=2^15;          %get a mask of the uncertain values
    mband(mband>=2^15)=omax;
    tband=imresize(mband,1/10,'nearest');   %decimation
    tband=medfilt2(tband,[5,5]);            %median filtering
    tband=imresize(tband,[rowsize,colsize],'bicubic');     %upsampling
    tband=medfilt2(tband,[3,3]);            %median  filtering
    tband=tband.*maskofunusablepix;         %keep only the aplicable results
    mband(band>=2^15)=0;                    %set vals to zero to add the results
    tband=mband+tband;                      %preresults with candidate restored data
    tband=filter2(fspecial('average',3),tband); %mean filtering to smooth transitions
    tband=tband.*maskofunusablepix;         %keep only the aplicable results
    tband=mband+tband;                      %preresults with candidate restored data
    tband=mean(cat(3,filter2(fspecial('average',3),tband), ...
                     medfilt2(tband,[3,3])),3); %mean between, mean and median filt
    tband=tband.*maskofunusablepix;         %keep only the aplicable results
    tband=mband+tband;                      %preresults with candidate restored data

    %result is in tband

    %% Uncertainty based on UI
    % All pixels will be averaged with a weight based on the Certainty Index
    %
    % What we do is weight the original band by its CI and also weight the
    % mean filtered [3,3] origial band by its rational UI=1-CI.  Then we take the average,
    % which is an actual weigthed average.

    mband=tband;
    tband=mean(cat(3,filter2(fspecial('average',5),mband).*(1-ciBn), ...
                     mband.*ciBn),3); %weighted average

    %result is in tband

    %% Output
    rband=tband;
    rband=rband-min(rband(:));
    rband=rband./max(rband(:));
    rband=rband.*(omax-omin);
    rband=rband+omin;
    % rband([1,2,3,size(rband,1)-2,size(rband,1)-1,size(rband,1)],:)=((rband([1,2,3,size(rband,1)-2,size(rband,1)-1,size(rband,1)],:).*0.45)+(band([1,2,3,size(band,1)-2,size(band,1)-1,size(band,1)],:).*0.55));
    % rband(:,[1,2,3,size(rband,2)-2,size(rband,2)-1,size(rband,2)])=((rband(:,[1,2,3,size(rband,2)-2,size(rband,2)-1,size(rband,2)]).*0.45)+(band(:,[1,2,3,size(band,2)-2,size(band,2)-1,size(band,2)]).*0.55));
end

function [Ackerman,Hao]=fpaperBenchmark(B20,B30,B31,B32)
% Input:
%               
%
% Output:
%
%
%   Example:
%
%    
    %first ackerman: B31-B32
    Ackerman=single(B31.icoi-B32.icoi);
    
    %second Hao: c0+c1*B20+c2*B30+c3*B31+c4*B32
    c0=-7.9370;
    c1=0.1227;
    c2=0.0260;
    c3=-0.7068;
    c4=0.5883;
    
    %Hao=single(c0+(B20.ioi)*c1+(B30.ioi).*c2+(B31.ioi).*c3+(B32.ioi).*c4);
    Hao=single(c0+(B20.icoi)*c1+(B30.icoi).*c2+(B31.icoi).*c3+(B32.icoi).*c4);
    
end 


function fpaperDetectDustRaw(B31,B32,confpath)
    warning('off','MATLAB:nearlySingularMatrix');
    %load PD
    fprintf('PD ');
    PDres=uint8((fTestPDFDust3231EvalPDF(confpath, B32-B31, 'global','16','nor')).*255); 
%     sizePDres=size(PDres);
    save('tmpclass.mat','PDres'); clear PDres;
    fprintf(' ========================================> done.');
        
    clear PNNres idx spread input PNNrestmp P r rrow c totmu totsigma pnnet sizePDres;
    
    clear P ffnnet latit longi inffile mydustmap pnnet c r input PDrestmp MLErestmp MAPrestmp FFNNrestmp PNNrestmp B20 B29 B31 B32 rrow spread totmu totsigma idx; 
%     load('tmpclass.mat', 'PDres'); 
%     x=single(PDres)./255; clear PDres; 
%     
%     rate=uint8((x.*(x>0.6)).*255);
%     save('tmpclass.mat','rate','-append'); clear rate; 
%     x=uint8(x.*255); 
%     save('tmpclass.mat','x','-append'); 
%     
%     load([confpath 'pinkmap.mat']); 
%     y=uint8(round(prpind2rgb(gray2ind(x),map).*255)); clear x; 
%     save('tmpclass.mat','y','-append'); clear y mapdisp confpath datapath map;    
    
    warning('on','MATLAB:nearlySingularMatrix');
end


function [Y]=fMLClassifier(feats,datapath)
    load(datapath,'muvect','sigmavect','pdfofC');
    Y=zeros(size(muvect,1),size(feats,2)); tmp=zeros(size(Y'));
    for k=1:size(muvect,1)
        hmu=muvect{k};
        hsigma=sigmavect{k};
        Y(k,:)=((mvnpdf(feats',hmu,hsigma)./mvnpdf(hmu,hmu,hsigma))*pdfofC(k))';
    end
end



function [bandp]=fTestPDFDust3231EvalPDF(confpath, msband, typeofestimation,typeofdata,typeofdist)
    load([confpath 'EstimatePDFDust3231.mat'],'EstimatedParamsPDF');
    eval(['pdfp=EstimatedParamsPDF.e' typeofestimation ';']);
    eval(['pdfp=pdfp.f' typeofdata ';']);
    eval(['pdfp=pdfp.' typeofdist ';']);
    switch typeofdist
        case 'nor'
            bandp=normpdf(msband,pdfp.mu,pdfp.sigma)./normpdf(pdfp.mu,pdfp.mu,pdfp.sigma);
        case 'gev'
            bandp=gevpdf(msband,pdfp.K,pdfp.sigma,pdfp.mu)./gevpdf(pdfp.mu,pdfp.K,pdfp.sigma,pdfp.mu);
    end
end

function [UpScaledData]=pfInterpUpScaleData(Data,BlockSize)
    maxrows=size(Data,1);
    for row=1:BlockSize:maxrows-BlockSize
        block=imresize(Data(row:row+(BlockSize-1),:),2,'bilinear');
        if row==1
            upblock=block;
        else
            upblock=cat(1,upblock,block);
        end
    end
    block=imresize(Data(row+BlockSize:maxrows,:),2,'bilinear');

    UpScaledData=cat(1,upblock,block);

end

function [rout,g,b] = prpind2rgb(a,cm)
    %IND2RGB Convert indexed image to RGB image.
    %   RGB = IND2RGB(X,MAP) converts the matrix X and corresponding
    %   colormap MAP to RGB (truecolor) format.
    %
    %   Class Support
    %   -------------
    %   X can be of class uint8, uint16, or double. RGB is an 
    %   M-by-N-by-3 array of class double.
    %
    %   See also RGB2IND.

    %   Clay M. Thompson 9-29-92
    %   Copyright 1984-2010 The MathWorks, Inc. 
    %   $Revision: 1.10.4.2 $  $Date: 2010/05/20 02:27:31 $

    if ~isfloat(a)
        a = single(a)+1;    % Switch to one based indexing
    end

    error(nargchk(2,2,nargin));

    % Make sure A is in the range from 1 to size(cm,1)
    a = max(1,min(a,size(cm,1)));

    % Extract r,g,b components
    rout = zeros([size(a),3],'single');
    t = single(zeros(size(a))); 
    t(:) = cm(a,1); rout(:,:,1) = t;
    t(:) = cm(a,2); rout(:,:,2) = t;
    t(:) = cm(a,3); rout(:,:,3) = t;
    clear t;
%       
%     r = zeros(size(a)); r(:) = cm(a,1);
%     g = zeros(size(a)); g(:) = cm(a,2);
%     b = zeros(size(a)); b(:) = cm(a,3);

    
end

function ReprojectAndSave(ResVarName, Latitude, Longitude, Resolution, filedirectory, filename)
    eval(['load(''tmpclass.mat'',''' ResVarName ''');']); 
    if strcmp(ResVarName,'x')
        ResVarName='Res'; Res=x; clear x;
    end
    eval(['imwrite(' ResVarName ',''' filedirectory '/' filename '-' Resolution '.jpg'',''jpg'');']); 
    eval(['imwrite(imresize(medfilt2(' ResVarName ',[20 20]),[102 68]),''' filedirectory '/' filename '-thumb.jpg'',''jpg'');']); 
    
    eval([ ResVarName '=pfMercatorReprojectData(' ResVarName ', Latitude, Longitude, ''' Resolution ''');']);
    eval(['imwrite(' ResVarName ',''' filedirectory '/' filename '-' Resolution '-r.jpg'',''jpg'');']); 
    eval(['imwrite(imresize(medfilt2(' ResVarName ',[20 20]),1/20),''' filedirectory '/' filename '-thumb-r.jpg'',''jpg'');']); 
end
