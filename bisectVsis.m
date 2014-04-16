function bisectVsis(startingImagePath, startingSavePath)

if ~exist('startingImagePath', 'var')
    startingImagePath = '/hms/scratch1/sr235/ccValidation_03-18-14';
end

if ~exist('startingSavePath', 'var')
    startingSavePath = '/hms/scratch1/sr235/ccValidation_03-18-14_hemisphere_tifs';
end
% Find VSIs 
vsiFiles = findVsis(startingImagePath, startingSavePath);

for i = 1:length(vsiFiles)
% Load VSI
    vsi = bfopen(vsiFiles(i).path);

% Construct RGB image
    rgb = zeros([size(vsi{1,1}{1,1}), 3]);
    rgb(:,:,2) = mat2gray(vsi{1,1}{2,1});
    rgb(:,:,3) = mat2gray(vsi{1,1}{1,1});

    imageWidth = size(vsi{1,1}{1,1}, 2);
    % Sample right hemisphere
    sampleIm = rgb(:, 1:ceil(imageWidth*4/7), :);            
    % Save sample
    [~, nameNoExt] = fileparts(vsiFiles(i).name);
    writeName = [nameNoExt, '-R.tif'];
    imwrite(sampleIm, fullfile(vsiFiles(i).dataPath, writeName))

    % Sample left hemisphere
    sampleIm = rgb(:, imageWidth*floor(3/7:imageWidth), :);
    % Save
    writeName = [nameNoExt, '-L.tif'];
    imwrite(sampleIm, fullfile(vsiFiles(i).dataPath, writeName))
end


function vsiFiles = findVsis(locationPath, savePath)
    vsiFiles = [];

    % Search locationPath
    locationPathContents = dirNoDot(locationPath);
    if length(locationPathContents) == 0
        return
    end
    
    % Create vsiData objects for files with .vsi extensions
    for i = 1:length(locationPathContents)
        [~, ~, ext] = fileparts(locationPathContents(i).name);
        if any(strcmpi(ext, '.vsi'))
            if ~exist('vsiFiles', 'var') || isempty(vsiFiles)
                vsiFiles = vsiData(locationPathContents(i), locationPath, savePath);
            else
                vsiFiles(end + 1) = vsiData(locationPathContents(i), locationPath, savePath);
            end
        end
    end


    % Recursively search directories
    directories = locationPathContents([locationPathContents(:).isdir]);
    for i = 1:length(directories)
        % Construct paths to vsi files and to data locations
        vsiPath = fullfile(locationPath, directories(i).name);
        dumpPath = fullfile(savePath, directories(i).name);
        if isempty(vsiFiles)
            vsiFiles = findVsis(vsiPath, dumpPath);
        else
            incomingVsiFiles = findVsis(vsiPath, dumpPath);
            if ~isempty(incomingVsiFiles)
                vsiFiles = [vsiFiles, incomingVsiFiles];
            end
        end
    end
