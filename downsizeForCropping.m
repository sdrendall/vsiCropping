function downsizeForCropping(imagePaths, outputPaths)
    %% Takes cell arrays imagePaths and outputPaths
    % resizes images in imagePaths to 1/8 size then saves them in outputPaths
    % 
    % also creates .mat files which will be used to save metadata about the images
    % 
    % outputPaths shouldn't contain file type (i.e. .tif, .mat)


parfor i = 1:length(imagePaths)
    
    % load image
    im = imread(imagePaths{i});

    % resize image
    im = imresize(im, .0125);

    % save to output
    imwrite(im, [outputPaths{i}, '.jpg'])

    % create .mat file
    originalImagePath = imagePaths{i};
    save(outputPaths{i}, 'originalImagePath')
end