-- 4. Создайте таблицу shipping_info, справочник комиссий по странам,
-- с уникальными доставками shipping_id и свяжите ее с созданными справочниками
-- shipping_country_rates, shipping_agreement, shipping_transfer и
-- константной информации о доставке shipping_plan_datetime, payment_amount, vendor_id.


DROP TABLE IF EXISTS public.shipping_info;

CREATE TABLE public.shipping_info (
	shipping_id                 int,
    shipping_plan_datetime      TIMESTAMP,
    payment_amount              NUMERIC(14,2),
	vendor_id                   smallint,
    shipping_country_rate_id    int,
    shipping_agreement_id       int,
    shipping_transfer_id        int,
	PRIMARY KEY (shipping_id),
    FOREIGN KEY (shipping_country_rate_id) REFERENCES public.shipping_country_rates (id) ON UPDATE CASCADE,
    FOREIGN KEY (shipping_agreement_id) REFERENCES public.shipping_agreement (agreement_id) ON UPDATE CASCADE,
	FOREIGN KEY (shipping_transfer_id) REFERENCES public.shipping_transfer (id) ON UPDATE CASCADE
);

INSERT INTO public.shipping_info
            (shipping_id, vendor_id, payment_amount, shipping_plan_datetime,
            shipping_transfer_id, shipping_agreement_id, shipping_country_rate_id)

WITH transfers AS (
    SELECT	
        id, 
        concat(transfer_type,':',transfer_model) AS shipping_transfer_description,
        shipping_transfer_rate
    FROM 
        public.shipping_transfer
)

SELECT
    DISTINCT 
        shippings.shipping_id AS shipping_id, 
        shippings.vendor_id AS vendor_id,
        shippings.payment_amount,
        shippings.shipping_plan_datetime,
        transfers.id,
        (regexp_split_to_array(shippings.vendor_agreement_description , E'\\:+'))[1]::int AS shipping_agreement_id,
        rates.id AS shipping_country_rate_id	
FROM
	public.shipping AS shippings
    LEFT JOIN transfers
        ON (shippings.shipping_transfer_description = transfers.shipping_transfer_description 
        AND shippings.shipping_transfer_rate = transfers.shipping_transfer_rate)
	LEFT JOIN public.shipping_country_rates AS rates
        ON shippings.shipping_country_base_rate = rates.shipping_country_base_rate

ORDER BY shipping_id;
