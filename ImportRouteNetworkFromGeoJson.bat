SET db=-f "PostgreSQL" PG:"dbname=FTTH_TEST user=postgres password=postgres"

SET coordInfo=-s_srs "EPSG:4326" -t_srs "EPSG:25832"

REM SET PGCLIENTENCODING=LATIN1

ogr2ogr %db% %coordInfo% C:\data\OpenFTTH\RouteNodes.geojson -overwrite -skipfailures -nln Location.RouteNode
ogr2ogr %db% %coordInfo% C:\data\OpenFTTH\RouteSegments.geojson -overwrite -skipfailures -nln Location.RouteSegment