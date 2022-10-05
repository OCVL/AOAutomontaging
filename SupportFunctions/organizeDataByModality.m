function [inData, MN, errorFlag] = organizeDataByModality(imageDir, ModalitiesSrchStrings, device_mode)

Allfiles = dir(fullfile(imageDir,'*.tif'));
Allfiles = cat(1, Allfiles, dir(fullfile(imageDir,'*.png')) );
Allfiles = {Allfiles.name};


inData = [];
errorFlag=0;

if strcmp(device_mode, 'meao')

    allmodes = cell(length(Allfiles),1);

    for f=1:length(Allfiles)
        splitString = textscan(Allfiles{f}, '%s', 'Delimiter', '_');
        splitString = splitString{1}; % First pull out the string itself.
        allmodes{f} = regexprep(splitString{7}, '[0-9]+$','');
    end
    ModalitiesSrchStrings = unique(allmodes);
end

MN = size(ModalitiesSrchStrings,1);

%create multi-modal data structure
%depending on parameter array ModalitiesSrchStrings
counter = 0;
for m = 1:MN
    if (~isempty(ModalitiesSrchStrings{m}))%check it's not empty
        imagesFound = sort(Allfiles(~cellfun(@isempty, strfind(Allfiles, ModalitiesSrchStrings{m}))));%search for image of this modality
        if(~isempty(imagesFound))
            if size(imagesFound,2) == size(inData,2) || isempty(inData)
                inData = [inData; imagesFound];
                counter = counter + 1;
            else
                imagesFound
                errorFlag = ['Error: Mismatch detected. Dataset must have the same number of modalities.'];
                return
            end
        end
        
    end
end
MN = counter;%only using nonempty identifiers

% Go through each column, stripping out modality information. What
% remains should be the same if we have 1:1 correspondence. If not,
% throw an error.
for n = 1:size(inData,2)
    compstrs = cell(MN,1);
    for m=1:MN
        if ~isempty(ModalitiesSrchStrings{m})
            compstrs{m} = strrep(inData{m,n},ModalitiesSrchStrings{m},'');
        end
    end
    allens = cellfun(@length,compstrs);
    if ~all(allens(1) == allens)
        errorFlag = ['Error: All image pairs/tuples must have all available modalities. Check image ' inData{1,n} '.'];
        return
    end
    compstrs=cell2mat(compstrs);
    for m=1:MN
        if ~all(compstrs(1,:) == compstrs(m,:))
            errorFlag = ['Error: All image pairs/tuples must have all available modalities. Check image ' inData{m,n} '.'];
            return
        end
    end
end



