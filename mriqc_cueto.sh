# Config ajustada para laptop con 8GB RAM física.
# El nodo synthstrip (deep learning) de MRIQC puede generar picos de memoria
# muy por encima de lo normal, por eso el swap alto (--memory-swap 24g)
# y el procesamiento anat/func separado.
# Requiere .wslconfig con memory=5GB y swap=20GB configurado en Windows.

for sub in 112 115 206 310 417 516 603 607; do

  echo "=========================================="
  echo "  Procesando sujeto: ${sub} - Anatómico"
  echo "=========================================="

  rm -rf /mnt/d/Neuro3_v2/Garza/derivatives/mriqc/sub-${sub}*
  sudo docker run --rm -v /mnt/d/Neuro3_v2/Garza/mriqc_work:/work busybox rm -rf /work/*
  sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
  sleep 5

  sudo docker run -ti --rm \
    -m 4.5g --memory-swap 24g \
    -v /mnt/d/Neuro3_v2/Garza/data_00_basic:/data:ro \
    -v /mnt/d/Neuro3_v2/Garza/derivatives/mriqc:/out \
    -v /mnt/d/Neuro3_v2/Garza/mriqc_work:/work \
    nipreps/mriqc:latest \
    /data /out participant \
    -w /work --nprocs 1 --omp-nthreads 1 --mem 4000M \
    --no-sub --notrack --ants-settings Fast --bids-database-wipe \
    --participant-label ${sub} -m T1w

  echo "=========================================="
  echo "  Procesando sujeto: ${sub} - Funcional"
  echo "=========================================="

  sudo docker run --rm -v /mnt/d/Neuro3_v2/Garza/mriqc_work:/work busybox rm -rf /work/*
  sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
  sleep 5

  sudo docker run -ti --rm \
    -m 4.5g --memory-swap 24g \
    -v /mnt/d/Neuro3_v2/Garza/data_00_basic:/data:ro \
    -v /mnt/d/Neuro3_v2/Garza/derivatives/mriqc:/out \
    -v /mnt/d/Neuro3_v2/Garza/mriqc_work:/work \
    nipreps/mriqc:latest \
    /data /out participant \
    -w /work --nprocs 1 --omp-nthreads 1 --mem 4000M \
    --no-sub --notrack --ants-settings Fast --bids-database-wipe \
    --participant-label ${sub} -m bold

  echo "=========================================="
  echo "  Sujeto ${sub} finalizado"
  echo "=========================================="
done
