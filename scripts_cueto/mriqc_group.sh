sudo docker run -ti --rm \
  -m 4.5g \
  -v /mnt/d/Neuro3_v2/Garza/data_00_basic:/data:ro \
  -v /mnt/d/Neuro3_v2/Garza/derivatives/mriqc:/out \
  nipreps/mriqc:latest \
  /data /out group \
  --no-sub \
  --notrack
