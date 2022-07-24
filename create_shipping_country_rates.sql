DROP TABLE IF EXISTS public.shipping_country;
CREATE TABLE public.shipping_country_rates (
shipping_country_id serial,
shipping_country text,
shipping_country_base_rate numeric(14,3),
PRIMARY KEY (shipping_country_id));

INSERT INTO public.shipping_country_rates (shipping_country,shipping_country_base_rate)
SELECT shipping_country,shipping_country_base_rate
FROM shipping
GROUP BY shipping_country,shipping_country_base_rate;

select *
from shipping_country_rates;
