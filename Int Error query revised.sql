SELECT sr.SHIPMENT_GID,
  substr(sr.shipment_gid,5,17) as railcar,
  SUBSTR(sr.SHIPMENT_REFNUM_VALUE,46,14) AS ORDER_RELEASER,
  orr.order_release_name AS VIN,
  sh.SOURCE_LOCATION_GID as Origin,
  sh.DEST_LOCATION_GID as Destination,
  locref.location_refnum_value || '-' || locref2.location_refnum_value,
  TO_CHAR(utc.get_local_date(sr.INSERT_DATE, 'TMS.LONG BEACH'), 'YYYY-MM-DD HH24:MI:SS') as Insert_Date
FROM SHIPMENT_REFNUM sr, shipment sh, order_release orr, location_refnum locref, location_refnum locref2
WHERE 
locref.location_gid =  sh.SOURCE_LOCATION_GID 
and locref.location_refnum_qual_gid = 'TMS.LEGACY_CODE' 
and locref2.location_gid =  sh.DEST_LOCATION_GID 
and locref2.location_refnum_qual_gid = 'TMS.LEGACY_CODE'
AND orr.order_release_gid = SUBSTR(sr.SHIPMENT_REFNUM_VALUE,46,14)
AND sr.shipment_gid = sh.shipment_gid
AND sr.SHIPMENT_REFNUM_QUAL_GID = 'TLS.INT_ERROR'
AND sr.INSERT_DATE >SYSDATE-15
AND sr.SHIPMENT_REFNUM_VALUE NOT LIKE '%LOCATION%'
AND sr.SHIPMENT_REFNUM_VALUE NOT LIKE '%SERVICE_PROVIDER%'
ORDER BY sr.shipment_refnum_value;

select * from order_release where order_release_gid = 'TLS.1W64082332';

select * from shipment;

select SHIPMENT_GID, SHIPMENT_REFNUM_VALUE, INSERT_DATE from SHIPMENT_REFNUM where SHIPMENT_REFNUM_QUAL_GID = 'TLS.INT_ERROR' and INSERT_DATE>SYSDATE-7 order by shipment_refnum_value;

select orl.order_release_line_xid, su.ship_unit_xid, (select pi.packaged_item_xid from packaged_item pi where pi.packaged_item_gid=orl.packaged_item_gid) as Packaged_Item, (select sus.ship_unit_spec_xid from ship_unit_spec sus where sus.ship_unit_spec_gid=su.transport_handling_unit_gid) as Tier  from order_release_line orl, ship_unit su, order_release o where o.order_release_gid=orl.order_release_gid and orl.order_release_gid=su.order_release_gid and o.order_release_xid in ( '121653466')