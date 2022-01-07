# EMOSYNC_EyeGaze


1. Load VELOCITY and GAZE Data 
2. For each time serie DO the Local Detrending
3. For each obtained record find the SIN like ondulation
4. Calculate the phase of each SIN like
5. For each couple (triad, trial) of three signals, calculate the Order Parameter
(Kuramoto).
6. Calculates the SYNC WEAK, MEDIUM, HIGH, thresholds for all trials of a TRIAD
7. Save the results

Script GROUP_GAZ_VEL_HEART_2.m
Continues the analysis from results obtained with Script GROUP_GAZ_VEL_HEART.m

1. Calculates TIS (Time In Sync) and TTS (Time To Sync) of Order Parameter 
calculated for each couple (triad, trial)
2. Compares the TIS for each SYNC Level through anovas (and visualize with boxplot)
