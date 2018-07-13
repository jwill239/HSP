addpath("C:\\Users\\sae\\workspace\\jsonlab");

global plant_station;

plant=loadjson("plant_RMP.json", 'SimplifyCell',1);
line_idx=1;
line= plant.lines(line_idx);
plant_station=[];
for tank= line.tanks
  for station= tank{}.stations
    plant_station=[plant_station station];
  endfor
endfor

