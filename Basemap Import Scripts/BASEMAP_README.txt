*** NOTICE ***

Importing basemap data from scratch, takes quite a lot of processing time.
To get started more quickly, just snatch the FTTH_TEST Postgres database from the DatabaseBackup folder instead.

-------------------------------------------------------------------------------------------
All basemap data used in the test setup are public data available from kortforsyningen.dk

You need to create a login (it's free) to download the data.

Be aware that the data amount is quite big (> 10 GB), and that the ImportBasemap.bat script only imports a subset of the data.

-------------------------------------------------------------------------------------------
Steps to download and import Danish basemap data into Postgres database
-------------------------------------------------------------------------------------------
1) Create folder c:\data\basemap


Get Basemap data
-------------------------------------------------------------------------------------------
2) Download DK_MAPINFO_UTM32_EUREF89.zip from ftp://ftp.kortforsyningen.dk/grundlaeggende_landkortdata/fot/MAPINFO/

3) Copy FOT folderen from zip file to c:\data\basemap


Get Parcel data
-------------------------------------------------------------------------------------------
4) Download DK_MAPINFO_UTM32_EUREF89.zip from ftp://ftp.kortforsyningen.dk/matrikeldata/matrikelkort/MAPINFO/

5) Copy MINIMAKS folder from zip file to c:\data\basemap


Get Access and unit address data
-------------------------------------------------------------------------------------------
6) Download access adresses via the following url https://dawa.aws.dk/adgangsadresser?format=csv

7) Download unitadresses via the following url https://dawa.aws.dk/adresser?format=csv

8) Copy adgangsadresser file to c:\data\basemap and change extension to .csv


Get Road data
-------------------------------------------------------------------------------------------
9) Download Vejmidte-TAB_UTM32_EUREF89.zip from ftp://ftp.kortforsyningen.dk/grundlaeggende_landkortdata/landsdaekkende-vejdata/

10) Copy vejmidte_navn.tab to c:\data\basemap


Run the import script
-------------------------------------------------------------------------------------------
11) ImportBasemap.bat




