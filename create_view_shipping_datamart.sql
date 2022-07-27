drop view if exists shipping_datamart;

create view shipping_datamart as
select 
	si.shippingid,
	si.vendorid,
	st.transfer_type,
	DATE_PART('DAY', AGE(shipping_status.shipping_end_fact_datetime, shipping_status.shipping_start_fact_datetime)) as full_day_at_shipping,
	case
		when shipping_status.shipping_end_fact_datetime>si.shipping_plan_datetime then 1
		else 0
	end as is_delayed,
	case
		when shipping_status.status = 'finished' then 1
		else 0
	end as is_shipping_finish,
	case
		when shipping_status.shipping_end_fact_datetime>si.shipping_plan_datetime then DATE_PART('DAY', AGE(shipping_status.shipping_end_fact_datetime, si.shipping_plan_datetime))
		else 0
	end as delay_day_at_shipping,
	si.payment_amount,
	si.payment_amount * (scr.shipping_country_base_rate + shipping_agreement.agreement_rate + st.shopping_transfer_rate) as vat,
	si.payment_amount * shipping_agreement.agreement_commission as profit
from
	shipping_info si
left join shipping_transfer st on
	si.transfer_type_id = st.transfer_type_id
left join shipping_status on
	si.shippingid = shipping_status.shippingid
left join shipping_country_rates scr on
	si.shipping_country_id = scr.shipping_country_id
left join shipping_agreement on
	si.agreementid = shipping_agreement.agreementid;

select
	*
from
	shipping_datamart
limit 10;