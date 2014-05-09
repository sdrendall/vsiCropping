function downsizeTiffs(imagePaths, outputPaths)
%% Given a cell array of image paths, outputs images at imagePaths to the corresponding
% outputPath

parfor i = 1:length(imagePaths)
    % load and resize
    im = imresize(imread(imagePaths{i}), [NaN, 800]);

    % normalize - may lose dynamic range.  Fine for this purpose.
    im = mat2gray(im);

    imwrite(im, outputPaths{i})
end