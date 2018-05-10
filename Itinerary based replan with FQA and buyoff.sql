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
AND or2.order_release_gid NOT IN
  (SELECT DISTINCT orl.order_release_gid
  FROM view_shipment_order_release vs,
    shipment sh,
    order_release orl
  WHERE (sh.indicator            IN ('Y', 'R', 'G')
  OR sh.transport_mode_gid        = 'TLS.RAILCAR')
  AND sh.shipment_gid             = vs.shipment_gid
  AND vs.order_release_gid        = orl.order_release_gid
  AND orl.assigned_itinerary_gid IN ('TLS.LGBCH_SADGO_ORILA_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_SEATL_JUNEA_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_SEATL_KETCH_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_SEATL_SITKA_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_TACOM_ANCHR_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_TACOM_KODIK_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_TACOM_SEWAR_DLR_REGION', 'TLS.LGBCH_SADGO_STJOO_DLR_REGION')
    )
AND or2.assigned_itinerary_gid in ('TLS.LGBCH_SADGO_ORILA_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_SEATL_JUNEA_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_SEATL_KETCH_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_SEATL_SITKA_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_TACOM_ANCHR_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_TACOM_KODIK_DLR_REGION', 'TLS.LGBCH_SADGO_ORILA_TACOM_SEWAR_DLR_REGION', 'TLS.LGBCH_SADGO_STJOO_DLR_REGION')
and or2.early_pickup_date > '01-JAN-17'
AND os.status_type_gid          ='TLS.FQA'
AND os1.status_type_gid          ='TLS.BUY_OFF';

select * from itinerary where itinerary_type = 'A';

select * from shipment where shipment_gid ='TLS.961009970';

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
AND or2.order_release_gid NOT IN
  (SELECT DISTINCT orl.order_release_gid
  FROM view_shipment_order_release vs,
    shipment sh,
    order_release orl
  WHERE (sh.indicator            IN ('Y', 'R', 'G')
  OR sh.transport_mode_gid        = 'TLS.RAILCAR')
  AND sh.shipment_gid             = vs.shipment_gid
  AND vs.order_release_gid        = orl.order_release_gid
  AND orl.assigned_itinerary_gid in ('TLS.GALT_BUFF_DOTOR_DLR_REGION', 'TLS.GALT_BUFF_EASBR_DLR_REGION', 'TLS.GALT_DET_ANPJC_DLR_REGION')
  )
AND or2.assigned_itinerary_gid IN ('TLS.GALT_BUFF_DOTOR_DLR_REGION', 'TLS.GALT_BUFF_EASBR_DLR_REGION', 'TLS.GALT_DET_ANPJC_DLR_REGION')
AND or2.dest_location_gid      IN ('TMS.DLR_06051', 'TMS.DLR_06917', 'TMS.DLR_06919', 'TMS.DLR_07987', 'TMS.DLR_20016', 'TMS.DLR_20133', 'TMS.DLR_20134', 'TMS.DLR_20917', 'TMS.DLR_31176', 'TMS.DLR_31541', 'TMS.DLR_31896', 'TMS.DLR_37714', 'TMS.DLR_37765', 'TMS.DLR_37778', 'TMS.DLR_37813', 'TMS.DLR_37861', 'TMS.DLR_37873', 'TMS.DLR_37878', 'TMS.DLR_37904', 'TMS.DLR_37923', 'TMS.DLR_37978', 'TMS.DLR_37992', 'TMS.DLR_47013', 'TMS.DLR_47917', 'TMS.DLR_47919', 'TMS.DLR_63731', 'TMS.DLR_63710', 'TMS.DLR_63709', 'TMS.DLR_63705', 'TMS.DLR_63704', 'TMS.DLR_63702', 'TMS.DLR_63701', 'TMS.DLR_63134', 'TMS.DLR_63133', 'TMS.DLR_63109', 'TMS.DLR_62903', 'TMS.DLR_62003', 'TMS.DLR_61930', 'TMS.DLR_61905', 'TMS.DLR_61904', 'TMS.DLR_61903', 'TMS.DLR_61902', 'TMS.DLR_60702', 'TMS.DLR_60605', 'TMS.DLR_60603', 'TMS.DLR_60602', 'TMS.DLR_60601')
AND os.status_type_gid          ='TLS.FQA'
AND os1.status_type_gid          ='TLS.BUY_OFF';
--AND   OS1.STATUS_VALUE_GID = 'TLS.BUY_OFF_NOT_RCVD'