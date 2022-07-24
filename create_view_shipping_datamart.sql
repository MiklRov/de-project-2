drop view if exists shipping_datamart;

create view shipping_datamart as
select 
	shipping_info.shippingid,
	shipping_info.vendorid,
	shipping_transfer.transfer_type,
	DATE_PART('DAY', AGE(shipping_status.shipping_end_fact_datetime, shipping_status.shipping_start_fact_datetime)) as full_day_at_shipping,
	(case
		when shipping_status.shipping_end_fact_datetime>shipping_info.shipping_plan_datetime then 1
		else 0
	end) as is_delayed,
	(case
		when shipping_status.status = 'finished' then 1
		else 0
	end) as is_shipping_finish,
	(case
		when shipping_status.shipping_end_fact_datetime>shipping_info.shipping_plan_datetime then DATE_PART('DAY', AGE(shipping_status.shipping_end_fact_datetime, shipping_info.shipping_plan_datetime))
		else 0
	end) as delay_day_at_shipping,
	shipping_info.payment_amount,
	shipping_info.payment_amount * (shipping_country.shipping_country_base_rate + shipping_agreement.agreement_rate + shipping_transfer.shopping_transfer_rate) as vat,
	shipping_info.payment_amount * shipping_agreement.agreement_commission as profit
from
	shipping_info
left join shipping_transfer on
	shipping_info.transfer_type_id = shipping_transfer.transfer_type_id
left join shipping_status on
	shipping_info.shippingid = shipping_status.shippingid
left join shipping_country on
	shipping_info.shipping_country_id = shipping_country.shipping_country_id
left join shipping_agreement on
	shipping_info.agreementid = shipping_agreement.agreementid;

select
	*
from
	shipping_datamart
limit 10;