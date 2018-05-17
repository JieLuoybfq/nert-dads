function rfscript(julianday,thisyear,datatodownload,datapath,modelpath)
granule='-';

while 1
     fid = fopen(datatodownload,'r+');  % Open text file
     while (~feof(fid))                                   % For each block:
         % julianday=sprintf('%03d',datenum(date)-datenum('0/0/2012'));
         % julianday='310';      
         fgranule=fgetl(fid);
         if ~isempty(fgranule) && strcmp(fgranule(length(fgranule)),'n') && strcmp(fgranule(length(fgranule)-2),'y')
             granule=fgranule(1:length(fgranule)-4);
             fprintf(['\nProcessing granule ' granule '...']);
             location = ftell(fid)-2;
             fseek(fid,location,'bof');
             fprintf(fid,'p');
             fclose(fid);
             %check if already processed before
             fileprocessed=[datapath '/' thisyear '/' julianday '/' granule '/' granule '-1km.jpg']; 
             j=dir(fileprocessed); 
             if ~isempty(j) %it is already processed, then update and break
                 fprintf(' is already processed.');
                 delete([datapath '/' thisyear '/' julianday '/' granule '/*.hdf']);
                 %update to finished
                 fid = fopen(datatodownload,'r+');  % Open text file
                 while (~feof(fid))                                   % For each block:
                     fgranule=fgetl(fid);
                     if ~isempty(fgranule) && strcmp(fgranule(length(fgranule)),'p')
                         cgranule=fgranule(1:length(fgranule)-4);
                         if strcmp(cgranule,granule)
                            location = ftell(fid)-2;
                            fseek(fid,location,'bof');
                            fprintf(fid,'y');
                            fclose(fid);
                            break;
                         end
                     end
                 end             
                 %=====
                 break;
             end
             %run detection
             prevdir=cd;
             cd(modelpath);
             classifiersdir=[modelpath '/'];
             startdir=[datapath '/' thisyear '/' julianday '/' granule]; 
             try
                [ptime]=fRealTimeDust(startdir,classifiersdir);
                delete([datapath '/' thisyear '/' julianday '/' granule '/*.hdf']);
                cd(prevdir);
                %update to finished
                fid = fopen(datatodownload,'r+');  % Open text file
                while (~feof(fid))                                   % For each block:
                    fgranule=fgetl(fid);
                    if ~isempty(fgranule) && strcmp(fgranule(length(fgranule)),'p')
                        cgranule=fgranule(1:length(fgranule)-4);
                        if strcmp(cgranule,granule)
                            location = ftell(fid)-2;
                            fseek(fid,location,'bof');
                            fprintf(fid,'y');
                            fclose(fid);
                            break;
                        end
                    end
                end
                break;
             catch err
                if (strcmp(err.identifier,'MATLAB:imagesci:hdfquickinfo:invalidFile')) || (strcmp(err.identifier,'MATLAB:imagesci:hdfinfo:invalidFile')) || (strcmp(err.identifier,'MATLAB:imagesci:validate:fileOpen'))
                    fprintf('\nMATLAB:imagesci:hdfquickinfo:invalidFile\n');
                    fprintf(['\nError reading granules ' granule '...  deleting corrupted files...\n']);
                    delete([datapath '/' thisyear '/' julianday '/' granule '/*.hdf']);
                    cd(prevdir);
                    %update to NOT-finished
                    fid = fopen(datatodownload,'r+');  % Open text file
                    while (~feof(fid))                                   % For each block:
                        fgranule=fgetl(fid);
                        if ~isempty(fgranule) && strcmp(fgranule(length(fgranule)),'p')
                            cgranule=fgranule(1:length(fgranule)-4);
                            if strcmp(cgranule,granule)
                                location = ftell(fid)-2;
                                fseek(fid,location,'bof');
                                fprintf(fid,'n');
                                fclose(fid);
                                quit;
                            end
                        end
                    end
                    quit;
                else
                    rethrow(err);
                end
             end
         end
     end     

     if ~isempty(granule)
         granule='';
         %fprintf('\nWaiting ');
         %pause(round(abs(randn*2))); drawnow;
     else
         quit;
     end
end

end
