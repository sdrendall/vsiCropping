#! /bin/bash


for mouse in `find ~/sr235/ccValidation_03-18-14_croppedHemispheres_tifs -mindepth 2 -type d`
do
    ims=`find $mouse -type f -name "*.tif"`
    IFS="','"
    imPaths=\{\'${ims[*]}\'\}
    bsub -q short -W 3:00 -e ~/jobLogs/$mouse.err -o ~/jobLogs/$mouse.log -R "rusage[mem=16000]" matlab -nosplash -nojvm -r "downsizeTiffs($imPaths)"
done
