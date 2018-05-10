SELECT s.shipment_gid,
  s.servprov_gid,
  s.source_location_gid,
  s.dest_location_gid,
  s.start_time,
  s.end_time,
  s.rate_geo_gid,
  s.indicator,
  (SELECT ss.status_value_gid
  FROM shipment_status ss
  WHERE s.shipment_gid  =ss.shipment_gid
  AND ss.status_type_gid='TLS.PAYMENT'
  )                        AS PAYMENT,
  ROUND(loaded_distance,1) AS DISTANCE,
  ROUND(BASE1,4)           AS BASE1_COST,
  ROUND(BASE2,4)           AS BASE2_COST,
  ROUND(TIER_COST,2)       AS TIER_COST,
  TIER_CODE,
  TO_CHAR(COALESCE(base1,0)+COALESCE(base2,0)+COALESCE(tier_cost,0),'$9990.00') AS Matching_Cost_For_Carrier,
  ROUND(FSC_COST,2)                                                             AS FSC,
  ROUND(total_actual_cost,2)                                                    AS TotCost_incl_FSC,
  ins.invoice_gid,
  ROUND(i.BASE_CHARGE,4)    AS Invoice_Base,
  ROUND(i.OTHER_CHARGE,4)   AS Invoice_FSC,
  ROUND(i.net_amount_due,4) AS Invoice_Total
FROM shipment s,
  invoice_shipment ins,
  invoice i,
  (SELECT shipment_gid,
    MAX(BASE1) BASE1,
    MAX(BASE2) BASE2,
    MAX(FSC_COST) FSC_COST,
    MAX(TIER_COST) TIER_COST,
    MAX(TIER_CODE) TIER_CODE
  FROM
    (SELECT shipment_gid,
      CASE
        WHEN cost_type       = 'B'
        AND rate_geo_cost_seq=1
        THEN cost
      END AS BASE1,
      CASE
        WHEN cost_type       = 'B'
        AND rate_geo_cost_seq=2
        THEN cost
      END AS BASE2,
      CASE
        WHEN cost_type                      = 'A'
        AND SUBSTR(accessorial_code_gid,1,7)='TMS.FSC'
        THEN cost
      END AS FSC_COST,
      CASE
        WHEN cost_type                      = 'A'
        AND SUBSTR(accessorial_cost_gid,1,8)='TMS.TIER'
        THEN cost
      END AS TIER_COST,
      CASE
        WHEN cost_type                      = 'A'
        AND SUBSTR(accessorial_cost_gid,1,8)='TMS.TIER'
        THEN SUBSTR(accessorial_cost_gid,5,6)
      END AS TIER_CODE
    FROM shipment_cost
    )
  GROUP BY shipment_gid
  ) SC
WHERE s.shipment_gid=sc.shipment_gid
AND i.invoice_gid   =ins.invoice_gid
AND ins.shipment_gid=s.shipment_gid
AND s.shipment_gid IN ('TLS.965371521', 'TLS.965501077', 'TLS.965431646', 'TLS.963140780', 'TLS.965563388', 'TLS.965563603', 'TLS.965874012');

select * from rate_factor where rate_factor_source_gid like '%DOE%';