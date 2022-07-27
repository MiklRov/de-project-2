DROP TABLE IF EXISTS public.shipping_status;
create table public.shipping_status (
shippingid bigint,
status text,
state text,
shipping_start_fact_datetime timestamp,
shipping_end_fact_datetime timestamp,
PRIMARY KEY (shippingid));

INSERT INTO shipping_status
with max_datetime as (SELECT 
		shippingid,
		MAX(state_datetime) AS state_datetime
	FROM shipping
	GROUP BY shippingid)
SELECT 
	md.shippingid, 
	shipping.status,
	shipping.state,
	booked_state.shipping_start_fact_datetime,
	received_state.shipping_end_fact_datetime
FROM max_datetime md
LEFT JOIN shipping ON md.shippingid=shipping.shippingid AND md.state_datetime=shipping.state_datetime
LEFT JOIN (
	SELECT shippingid,state_datetime AS shipping_start_fact_datetime
	FROM shipping
	WHERE state='booked'
	) AS booked_state
ON md.shippingid=booked_state.shippingid
LEFT JOIN (
	SELECT shippingid,state_datetime AS shipping_end_fact_datetime
	FROM shipping
	WHERE state='received'
	) AS received_state
ON md.shippingid=received_state.shippingid
ORDER BY md.shippingid;

select *
from shipping_status
limit 10;