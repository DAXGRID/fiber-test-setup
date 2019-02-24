
-----------------------------------------------------------------------------------------------------------------
-- Import access and unit address information to location tables
-----------------------------------------------------------------------------------------------------------------

-- first delete everything but addresses belonging to the Vejle municipal, that is our test region
delete from "Basemap".temp_aws_adgadr where kommunekode is null or kommunekode <> '0630';

CREATE INDEX IF NOT EXISTS temp_aws_adgadr_id_idx ON "Basemap".temp_aws_adgadr(id);

delete from "Basemap".temp_aws_enhadr where not exists (select null from "Basemap".temp_aws_adgadr adg where adg.id = adgangsadresseid);
commit;

-- create spatial column on temp table
ALTER TABLE "Basemap".temp_aws_adgadr ADD COLUMN IF NOT EXISTS wkb_geometry geometry(Point,25832);
commit;

UPDATE "Basemap".temp_aws_adgadr
SET wkb_geometry = ST_GeomFromText('POINT(' || "etrs89koordinat_Ã¸st" || ' ' || "etrs89koordinat_nord"|| ')',25832)
where length("etrs89koordinat_Ã¸st") > 5;
commit;

-- transfer access addresses to location tables
truncate "Location"."AccessAddress";

insert into "Location"."AccessAddress" ("LocationId", "ExternalAccessAddressId", "PostalCode", "MunicipalCode", "RoadCode", "HouseNumber", "Coordinates")
select 
  nextval('"Location"."Location_LocationId_seq"'), 
  id,
  postnr,
  kommunekode,
  vejkode,
  husnr,  
  wkb_geometry
from "Basemap".temp_aws_adgadr;

-- don't call sequence generator, because we already snatched an id inserting into the entity derived from location
insert into "Location"."Location" ("LocationId", "MRID", "LocationOriginKind")
OVERRIDING SYSTEM VALUE
select 
  "LocationId",
  uuid_generate_v4(),
  'official'
from "Location"."AccessAddress";

commit;

-- transfer unit addresses to location tables
truncate "Location"."UnitAddress";

CREATE INDEX IF NOT EXISTS idx_location_access_address_externalaccessaddressid ON  "Location"."AccessAddress"("ExternalAccessAddressId");

insert into "Location"."UnitAddress" ("LocationId", "ExternalUnitAddressId", "FloorName", "RoomName", "AccessAddressId")
select 
  nextval('"Location"."Location_LocationId_seq"'), 
  id,
  etage,
  "dÃ¸r",
  ( select "LocationId" from "Location"."AccessAddress" aa
	inner join "Basemap".temp_aws_adgadr tmp_adg on tmp_adg.id = aa."ExternalAccessAddressId"
    where tmp_adg.id = adgangsadresseid
   )
from "Basemap".temp_aws_enhadr;

commit;


-----------------------------------------------------------------------------------------------------------------
-- Import buildings to location tables
-----------------------------------------------------------------------------------------------------------------
truncate "Location"."Building";

insert into "Location"."Building" ("LocationId", "ExternalBuildingId", "Coordinates")
select nextval('"Location"."Location_LocationId_seq"'), bygn_uuid, wkb_geometry
from "Basemap".building
where length(bygn_uuid) > 1;

-- don't call sequence generator, because we already snatched an id inserting into the entity derived from location
insert into "Location"."Location" ("LocationId", "MRID", "LocationOriginKind")
OVERRIDING SYSTEM VALUE
select 
  "LocationId",
  uuid_generate_v4(),
  'official'
from "Location"."Building";

commit;

-----------------------------------------------------------------------------------------------------------------
-- Import roads to location tables
-----------------------------------------------------------------------------------------------------------------
truncate "Location"."RoadSegment";

insert into "Location"."RoadSegment" ("LocationId", "MunicipalCode", "RoadCode", "Name", "Coordinates")
select 
  nextval('"Location"."Location_LocationId_seq"'), 
  kommunekode, 
  vejkode,
  vejnavn,
  wkb_geometry
from "Basemap".road_center;

-- don't call sequence generator, because we already snatched an id inserting into the entity derived from location
insert into "Location"."Location" ("LocationId", "MRID", "LocationOriginKind")
OVERRIDING SYSTEM VALUE
select 
  "LocationId",
  uuid_generate_v4(),
  'official'
from "Location"."RoadSegment";

commit;

