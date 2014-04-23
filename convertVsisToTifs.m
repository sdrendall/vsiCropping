function convertVsisToTifs(startingImagePath, startingSavePath)

if ~exist('startingImagePath', 'var')
    startingImagePath = '/hms/scratch1/sr235/ccValidation_03-18-14';
end

if ~exist('startingSavePath', 'var')
    startingSavePath = '/hms/scratch1/sr235/ccValidation_03-18-14_hemisphere_tifs';
end
% Find VSIs 
vsiFiles = findVsis(startingImagePath, startingSavePath);
maxDims = findLargestImageSize(vsiFiles);

for i = 1:length(vsiFiles)
    convertToTif(vsiFiles(i), maxDims)
end

function dims = findLargestImageSize(vsiFiles)
    dims = [0,0];
    for i = 1:length(vsiFiles)
        reader = bfGetReader(vsiFiles(i).path);
        m = reader.getMetadataStore();
        h = m.getPixelsSizeY(0).getValue();
        w = m.getPixelsSizeX(0).getValue();
        if h > dims(1)
            dims(1) = h;
        end
        if w > dims(2)
            dims(2) = w;
        end
    end


function convertToTif(vsiFile, targetDimensions)
    % Load VSI
    vsi = bfopen(vsiFile.path);

    % Construct RGB image
    marginSize = targetDimensions - size(vsi{1,1}{2,1});
    rgb = zeros([targetDimensions, 3]);
    rgb(:,:,2) = padarray(mat2gray(vsi{1,1}{2,1}), marginSize, 'post');
    rgb(:,:,3) = padarray(mat2gray(vsi{1,1}{1,1}), marginSize, 'post');

    % Save to tif
    [~, nameNoExt] = fileparts(vsiFile.name);
    writeName = [nameNoExt, '.tif'];
    imwrite(rgb, fullfile(vsiFile.dataPath, writeName))


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
