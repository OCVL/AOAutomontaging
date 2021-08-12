%Function used to parse the file names from the MEAO device
function [ eyeSide, LocXY, modality ] = parseMeaoFName( filenameStr )

%Parse MEAO AO images to find nominal coordinate locations and eye
%information

% File structure:
% Subject??_Session??_EYE_(X,Y)_imageDem_VisAngel_Modality_OtherInfo
% Subject11_Session37_OD_(0.2,-0.4)_1.5x1.5_468_CalculatedSplit1_extract_reg_avg


splitString = textscan(filenameStr, '%s', 'Delimiter', '_');
splitString = splitString{1};

eyeSide = splitString{3};
locStr = splitString{4};
modality = splitString{7};
modality = modality(1:end-1);

r = ["(", ")"];

newLocStr = erase(locStr, r);
locations = textscan(newLocStr, '%s', 'Delimiter', ',');
locations = locations{1};

X = convertCharsToStrings(locations{1});
Y = convertCharsToStrings(locations{2});

LocXY(1) = str2double(X);
LocXY(2) = str2double(Y);


end

