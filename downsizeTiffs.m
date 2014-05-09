function downsizeTiffs(imagePaths)
%% Given a cell array of image paths, outputs images at imagePaths to the corresponding
% outputPath

parfor i = 1:length(imagePaths)
    % load and resize
    im = imresize(imread(imagePaths{i}), [NaN, 800]);

    % Construct output
    [~, filename] = fileparts(imagePaths{i});
    outputDir = '/home/sr235/sr235/ccValidation_03-18-14_croppedHemispheres_tifs/downsized';
    outputPath = fullfile(outputDir, [filename, '_downsized.tif']);

    % normalize - may lose dynamic range.  Fine for this purpose.
    im = mat2gray(im);

    imwrite(im, outputPath)
end