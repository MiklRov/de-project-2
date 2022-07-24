drop table if exists public.shipping_transfer;

create table public.shipping_transfer (
transfer_type_id serial,
transfer_type text,
transfer_model text,
shopping_transfer_rate numeric(14,
3),
primary key (transfer_type_id));

insert
	into
	public.shipping_transfer (transfer_type,
	transfer_model,
	shopping_transfer_rate)
select
	distinct
	(regexp_split_to_array(shipping_transfer_description, ':'))[1]::text,
	(regexp_split_to_array(shipping_transfer_description, ':'))[2]::text,
	shipping_transfer_rate
from
	shipping;
	
select *
from shipping_transfer;