%Function used to parse the file names from the MEAO device
function [ eyeSide, LocXY, dem, id] = parseMeaoFName( filenameStr )

%Parse MEAO AO images to find nominal coordinate locations and eye
%information

% File structure:
% Subject??_Session??_EYE_(X,Y)_imageDem_VisAngel_Modality_OtherInfo
% Subject11_Session37_OD_(0.2,-0.4)_1.5x1.5_468_CalculatedSplit1_extract_reg_avg
% filenameStr = 'Subject11_Session37_OD_(0.2,-0.4)_1.5x1.5_468_760nm1_extract_reg_avg';


splitString = textscan(filenameStr, '%s', 'Delimiter', '_');
splitString = splitString{1};

% Eye and inital location information abstraction
eyeSide = splitString{3};
locStr = splitString{4};

% Subject ID that is the ID in the calling function
i = splitString{1};
i = textscan(i, '%s', 'Delimiter', 't');
i = i{1};
id = i{2};

% Size information abstraction
s = splitString{5};
dem = textscan(s, '%s', 'Delimiter', 'x');
dem = dem{1};

% Modality abstraction - currently not being returned since there is no var
% in the calling function at this instance
modality = splitString{7};
modality = modality(1:end-1);

% XY Location  
r = ["(", ")"];
newLocStr = erase(locStr, r);
locations = textscan(newLocStr, '%s', 'Delimiter', ',');
locations = locations{1};

X = convertCharsToStrings(locations{1});
Y = convertCharsToStrings(locations{2});

LocXY(1) = str2double(X);
LocXY(2) = str2double(Y);

end

