function specifyCropPoints(imagePaths, dataPaths, handles)
    %% Specifies verticies of ROIs to crop from vsi files.  
    % Intended to be passed paths to thumbnails or larger files, for speed
    % verticies are expressed as a ratio of total image dimensions (for arbitrary scaling)

figure
for i = 1:length(imagePaths)
    % Load data and image
    if exist(dataPaths{i}, 'file')
        imData = load(dataPaths{i});
    else
        imData = struct();
    end
    im = imread(imagePaths{i});

    % Get user input -- crop vertex coordinates
    imData = getInput(im, imData);

    % Save back to data file
    imData.thumbnailPath = imagePaths{i};
    save(dataPaths{i}, '-struct', 'imData')
end

function data = getInput(im, data)
    gettingInput = true;
    imshow(im)

