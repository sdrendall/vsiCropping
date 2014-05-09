#! /bin/bash


for mouse in `find ~/sr235/ccValidation_03-18-14_croppedHemispheres_tifs -mindepth 2 -type d`
do
    imPaths=`find $mouse -type f -name "*.tif"`
    outputPaths=`find $mouse -type f -name "*.tif" | cut -d '/' -f 8 | cut -d '.' -f 1`
    imPaths=\{\'${imPaths[*]}\'\}
    outputPaths=\{\'${outputPaths[*]}\'\}
    bsub -q short -W 3:00 -e ~/jobLogs/$mouse.err -o ~/jobLogs/$mouse.log -R "rusage[mem=16000]" matlab -nosplash -nojvm -r "downsizeTiffs($imPaths, $outputPaths)"
done
