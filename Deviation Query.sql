SELECT or2.order_release_xid,
  or2.order_release_name AS VIN,
  or2.assigned_itinerary_gid,
  or2.early_pickup_date,
    or2.source_location_gid,
  or2.dest_location_gid,
    OS.STATUS_VALUE_GID,
  OS1.STATUS_VALUE_GID
FROM Order_release or2,  order_release_status os, order_release_status os1
WHERE or2.order_release_gid    =os.order_release_gid
and os1.order_release_gid    =os.order_release_gid
AND or2.order_release_gid  IN
  (SELECT DISTINCT orl.order_release_gid
  FROM view_shipment_order_release vs,
    shipment sh,
    order_release orl
  WHERE (sh.shipment_gid like 'TLS.DEV%')
    )
and or2.early_pickup_date > '01-JAN-17'
AND os.status_type_gid          ='TLS.FQA'
AND os1.status_type_gid          ='TLS.BUY_OFF';


select 
or1.order_release_gid,
  (SELECT  
  LISTAGG(vs.shipment_gid || ',' || sh.source_location_gid,'; ') WITHIN GROUP (ORDER BY vs.shipment_gid)  "shipments"
  FROM view_shipment_order_release vs, shipment sh
  where (vs.order_release_gid like (or1.order_release_gid || '%') AND sh.shipment_gid=vs.shipment_gid)
  ) as SHIPMENTS
from
order_release or1 
where 
or1.order_release_gid like 'TLS.1Q75024457%'
and 
 or1.order_release_gid  IN
  (SELECT DISTINCT orl.order_release_gid
  FROM view_shipment_order_release vs,
    shipment sh,
    order_release orl
  WHERE (sh.shipment_gid like 'TLS.DEV%')
    )
  ;
    
  SELECT  
  LISTAGG(vs.shipment_gid || ',' || sh.source_location_gid,'; ') WITHIN GROUP (ORDER BY vs.shipment_gid)  "shipments"
  FROM view_shipment_order_release vs, shipment sh
  where 
  vs.order_release_gid like 'TLS.1Q75024457%' 
  AND sh.shipment_gid=vs.shipment_gid
  AND transport_mode_gid = 'TLS.TRUCK'
  ;


--DEVIATION QUERY WORKING
select * from 
(
select REGEXP_SUBSTR(or1.order_release_gid,'[^-]+') as ORDER_GID, or1.order_release_gid as DEV_ORDER_GID, or1.source_location_gid as Order_Rel_SOURCE, sh1.SERVPROV_GID as DEV_SERV_PROV, sh1.start_time, sh1.shipment_gid as DEV_SHIPMENT_GID, ss2.status_value_gid,
(select listagg(or2.order_release_name || ',' || vs.order_release_gid ||',' || vs.shipment_gid || ',' || sh.start_time || ',' || sh.source_location_gid || ',' || sh.dest_location_gid || ',' || sh.SERVPROV_GID || ',' || ss.status_value_gid || ',' || ROUND( or2.EARLY_PICKUP_DATE - sh.start_time,0), ';')  within group (order by vs.shipment_gid) "shipments"
 from shipment sh, view_shipment_order_release vs, shipment_status ss, order_release or2
 where 
 --(REGEXP_SUBSTR(vs.order_release_gid,'[^-]+')  = REGEXP_SUBSTR(or1.order_release_gid,'[^-]+') )
 (vs.order_release_gid = REGEXP_SUBSTR(or1.order_release_gid,'[^-]+') OR vs.order_release_gid = REGEXP_SUBSTR(or1.order_release_gid,'[^-]+')||'-001' OR vs.order_release_gid = REGEXP_SUBSTR(or1.order_release_gid,'[^-]+')||'-002' OR vs.order_release_gid = REGEXP_SUBSTR(or1.order_release_gid,'[^-]+')||'-003') --second order releases
 and vs.shipment_gid = sh.shipment_gid
 and or2.order_release_gid = vs.order_release_gid
 and sh.transport_mode_gid  = 'TLS.TRUCK'
 and sh.source_location_gid = or1.source_location_gid
 and sh.servprov_gid <> 'TMS.KN'
 and sh.shipment_gid = ss.shipment_gid
 AND ss.status_type_gid      ='TLS.PAYMENT'
 and ss.status_value_gid <> 'TLS.PAYMENT_VOUCHERED'--limit to not vouchered
 --and ABS(or1.EARLY_PICKUP_DATE - sh.start_time) < 3065   INCLUDE date of regular shipment and date of deviation
 ) as MATCHING_SHIPMENTS_TO_CLOSE
from order_release or1  
left join shipment sh1 on sh1.shipment_gid = 'TLS.DEV'||REGEXP_SUBSTR(or1.order_release_gid,'[-](.*)') 
left join shipment_status ss2 on sh1.shipment_gid = ss2.shipment_gid
WHERE or1.order_release_gid like '%-01%' and ss2.status_type_gid = 'TLS.SH_DEVIATION_REQUEST' and ss2.status_value_gid = 'TLS.SH_DEVIATION_REQUEST_APPROVED' --and or1.order_release_gid like '%186B065865%' --and or1.SERVPROV_GID <> 'CANCELLED'  --limit to approved deviations
)
where MATCHING_SHIPMENTS_TO_CLOSE is not null;

--DEVIATION QUERY WORKING

select * from shipment_status where status_value_gid like '%DEV%APP%';

select servprov_gid from order_release where order_release_gid = 'TLS.186B065865-017268'


select * from shipment where shipment_gid = 'TLS.962624946';    
select * from view_shipment_order_release where ORDER_RELEASE_GID like 'TLS.1Q75024457%';


select * from 
(
select 
(select COUNT(vs.order_release_gid) 
 from order_release vs
 where 
 REGEXP_SUBSTR(vs.order_release_gid,'[^-]+') = REGEXP_SUBSTR(or1.order_release_gid,'[^-]+') and vs.order_release_gid like '%-01%'
  --and ABS(or1.EARLY_PICKUP_DATE - sh.start_time) < 3065   INCLUDE date of regular shipment and date of deviation
 ) as NUMDEVS
from order_release or1  
WHERE or1.order_release_gid like '%-01%' and or1.INSERT_DATE > '01-MAY-17'--and or1.order_release_gid like '%186B065865%' --and or1.SERVPROV_GID <> 'CANCELLED'  --limit to approved deviations
)
where NUMDEVS >0;
 
