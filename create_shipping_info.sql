DROP TABLE IF EXISTS public.shipping_info;
CREATE TABLE public.shipping_info (
shippingid bigint,
vendorid bigint,
payment_amount NUMERIC(14,2),
shipping_plan_datetime timestamp,
transfer_type_id bigint,
shipping_country_id bigint,
agreementid bigint,
PRIMARY KEY (shippingid),
FOREIGN KEY (transfer_type_id) REFERENCES shipping_transfer (transfer_type_id),
FOREIGN KEY (shipping_country_id) REFERENCES shipping_country (shipping_country_id),
FOREIGN KEY (agreementid) REFERENCES shipping_agreement (agreementid)
);

INSERT INTO shipping_info
SELECT
	main_table.shippingid,
	main_table.vendorid,
	main_table.payment_amount,
	main_table.shipping_plan_datetime,
	shipping_transfer.transfer_type_id,
	shipping_country.shipping_country_id,
	shipping_agreement.agreementid
FROM (
	SELECT DISTINCT
		shippingid,
		vendorid,
		payment_amount,
		shipping_plan_datetime,
		shipping_transfer_description,
		shipping_country,
		vendor_agreement_description
	FROM shipping
	) AS main_table
LEFT JOIN shipping_transfer
ON 
	(regexp_split_to_array(main_table.shipping_transfer_description, ':'))[1]::text=shipping_transfer.transfer_type AND
	(regexp_split_to_array(main_table.shipping_transfer_description, ':'))[2]::text=shipping_transfer.transfer_model
LEFT JOIN shipping_country ON main_table.shipping_country=shipping_country.shipping_country
LEFT JOIN shipping_agreement
ON
	(regexp_split_to_array(main_table.vendor_agreement_description, ':'))[2]::text=shipping_agreement.agreement_number AND
	(regexp_split_to_array(main_table.vendor_agreement_description, ':'))[3]::NUMERIC(14,3)=shipping_agreement.agreement_rate AND
	(regexp_split_to_array(main_table.vendor_agreement_description, ':'))[4]::NUMERIC(14,3)=shipping_agreement.agreement_commission
ORDER BY main_table.shippingid;

select *
from shipping_info
limit 10;