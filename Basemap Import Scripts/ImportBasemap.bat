SET db=-f "PostgreSQL" PG:"dbname=FTTH_TEST user=postgres password=postgres"

SET coordInfo=-s_srs "EPSG:25832" -t_srs "EPSG:25832"

SET clip=-clipsrc 532250 6171197 542799 6178964

SET PGCLIENTENCODING=LATIN1

ogr2ogr %db% %coordInfo% %clip% C:\Data\Basemap\FOT\TRAFIK\VEJKANT.tab -overwrite -skipfailures -nln Basemap.road_edge
ogr2ogr %db% %coordInfo% %clip% C:\Data\Basemap\FOT\BYGNINGER\BYGNING.tab -overwrite -skipfailures -nln Basemap.building
ogr2ogr %db% %coordInfo% %clip% C:\Data\Basemap\VEJMIDTE_NAVN.tab -overwrite -skipfailures -nln Basemap.road_center

ogr2ogr %db% %coordInfo% %clip% C:\Data\Basemap\MINIMAKS\BASIS\SKEL.tab -overwrite -skipfailures -nln Basemap.plot_edge

ogr2ogr %db% %coordInfo% %clip% C:\Data\Basemap\adgangsadresser.csv -oo X_POSSIBLE_NAMES=x -oo Y_POSSIBLE_NAMES=y -overwrite -skipfailures -nln Basemap.access_address

ogr2ogr %db% "C:\Data\Basemap\adgangsadresser.csv" -nln Basemap.temp_aws_adgadr -overwrite
ogr2ogr %db% "C:\Data\Basemap\adresser.csv" -nln Basemap.temp_aws_enhadr -overwrite