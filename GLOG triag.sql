SELECT loc.location_gid,
  loc.location_name,
  loc.city,
  loc.province_code,
  loc.postal_code,
  locref.LOCATION_REFNUM_VALUE,
  c.address
FROM LOCATION_REFNUM locref,
  location loc
INNER JOIN(
  SELECT laz.location_gid,
    LISTAGG(laz.address_line,',') WITHIN GROUP (ORDER BY laz.LINE_SEQUENCE) AS address
  FROM location_address laz group by laz.location_gid
  ) c
ON c.location_gid = loc.location_gid
WHERE loc.location_gid LIKE 'TMS.DLR_82513'
AND locref.location_gid             = loc.location_gid;
--AND locref.location_refnum_qual_gid = 'TMS.SPLC_RDS';

select SHIPMENT_GID, SHIPMENT_REFNUM_VALUE, INSERT_DATE from SHIPMENT_REFNUM where SHIPMENT_REFNUM_QUAL_GID = 'TLS.INT_ERROR' and INSERT_DATE>SYSDATE-30 order by shipment_refnum_value;



select orl.order_release_gid, orl.order_release_line_xid, su.ship_unit_xid, (select pi.packaged_item_xid from packaged_item pi where pi.packaged_item_gid=orl.packaged_item_gid) as Packaged_Item, (select sus.ship_unit_spec_xid from ship_unit_spec sus where sus.ship_unit_spec_gid=su.transport_handling_unit_gid) as Tier  from order_release_line orl, ship_unit su, order_release o where o.order_release_gid=orl.order_release_gid and orl.order_release_gid=su.order_release_gid and o.order_release_xid in ('120700017', '120700019', '120696261', '120695643', '120696263', '120697201', '120697202', '120695590', '120697233', '120697893', '120699987', '120699997', '120700021', '120700034', '120696273', '120696276', '120695608', '120697254', '120696251', '120697896', '120697898', '120700070', '120697199', '120697864', '120701311', '120695633', '120695703', '120695667', '120695683', '120695623', '120696240', '120696265', '120695595', '120696268', '120699996', '120701289', '120696266', '120695637', '120695698', '120695699', '120695700', '120695701', '120695702', '120696318', '120696274', '120697223', '120697232', '120697236', '120697854', '120699982', '120700022', '120700023', '120700030', '120696300', '120697878', '120700073', '120700150', '120700165', '120700116', '120696241', '120696262', '120701390', '120697842', '120697849', '120697943', '120697203', '120700008', '120700032', '120696293');

select s.saved_query_gid,s.sql_check_one from saved_query s where s.saved_query_gid like '%FAILED%';


select s.saved_query_gid,s.sql_check_one from saved_query s where s.saved_query_gid='TLS.MONITOR-SHIPMENTS WITH INT_ERROR REFNUMS';


SELECT o.order_release_gid
  ,
  o.order_release_type_gid,
  o.source_location_gid,
  o.dest_location_gid
FROM ORDER_RELEASE o,
  ORDER_RELEASE_STATUS ors1
WHERE o.order_release_gid=ors1.order_release_gid
AND ors1.status_type_gid ='TLS.PLANNING'
AND ors1.status_value_gid='TLS.PLANNING_PLANNED - FAILED'
and o.dest_location_gid <> 'TMS.DLR_UNASSIGN'
AND ors1.update_date     >SYSDATE-45;

SELECT distinct sh.SHIPMENT_GID,sh.source_location_gid ||', '|| sh.dest_location_gid||', '|| sh.start_time||', '||sh.servprov_gid||', '||sh.first_equipment_group_gid||', '||sh.num_order_releases
FROM SHIPMENT sh WHERE sh.INSERT_DATE BETWEEN SYSDATE-15 AND sysdate-12/24 AND sh.TRANSPORT_MODE_GID = 'TLS.RAILCAR' and sh.source_location_gid <> 'TMS.SALAMANCA' AND sh.TOTAL_ACTUAL_COST ='0' AND sh.shipment_gid NOT IN
(SELECT SHIPMENT_GID
FROM shipment s
WHERE s.RATE_GEO_GID IN ('TMS.NS_RR_PRINC_CENTV_20140220','TMS.CPRS_RR_WODSK_WCHGO_20140307','TMS.NS_RR_PRINC_WCHGO_20140326')
) AND sh.shipment_gid NOT  IN (select sh.shipment_gid from shipment sh where sh.source_location_gid='TMS.WOODSTOCK' and sh.dest_location_gid='TMS.WEST CHICAGO' );