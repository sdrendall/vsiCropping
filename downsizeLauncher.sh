#! /bin/bash


for mouse in `find ~/sr235/ccValidation_03-18-14_croppedHemispheres_tifs -mindepth 2 -type d`
do
    ims=`find $mouse -type f -name "*.tif"`
    imPaths="\{\'$(echo ${ims[*]} | tr ' ' "\',\'")\'\}"
    echo $imPaths
    logName=`echo $mouse | cut -d '/' -f 7`
    bsub -q short -W 3:00 -e ~/jobLogs/$logName.err -o ~/jobLogs/$logName.log -R "rusage[mem=16000]" matlab -nosplash -nojvm -r "downsizeTiffs($imPaths)"
done
