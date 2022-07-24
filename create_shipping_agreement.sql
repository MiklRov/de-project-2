DROP TABLE IF EXISTS public.shipping_agreement;
CREATE TABLE public.shipping_agreement (
agreementid serial,
agreement_number text,
agreement_rate NUMERIC(14,3),
agreement_commission NUMERIC(14,3),
PRIMARY KEY (agreementid));

INSERT INTO shipping_agreement
SELECT DISTINCT
	(regexp_split_to_array(vendor_agreement_description, ':'))[1]::integer,
	(regexp_split_to_array(vendor_agreement_description, ':'))[2]::text,
	(regexp_split_to_array(vendor_agreement_description, ':'))[3]::NUMERIC(14,3),
	(regexp_split_to_array(vendor_agreement_description, ':'))[4]::NUMERIC(14,3)
FROM shipping
ORDER BY (regexp_split_to_array(vendor_agreement_description, ':'))[1]::integer;

select *
from shipping_agreement;