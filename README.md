# Shipping data warehouse

Normalising a single flat `shipping` table into a small warehouse: reference
tables, a fact table with foreign keys, a status table with calculated delivery
dates, and an analytical view on top.

## Steps

1. `create_shipping_country_rates.sql` - reference table of shipping rates by country
2. `create_shipping_agreement.sql` - vendor agreements and tariffs, parsed out of the source field
3. `create_shipping_transfer.sql` - reference table of delivery types
4. `create_shipping_info.sql` - core shipping table, with foreign keys to the three references above
5. `create_shipping_status.sql` - current status per shipment, with calculated delivery dates
6. `create_view_shipping_datamart.sql` - the analytical view: revenue, cost and delivery time per vendor

Written in SQL on PostgreSQL.
