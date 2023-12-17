-- 2. Создайте справочник тарифов доставки вендора по договору shipping_agreement
-- из данных строки vendor_agreement_description
-- через разделитель «:» (двоеточие без кавычек).
-- 
-- Названия полей:
-- agreement_id,
-- agreement_number,
-- agreement_rate,
-- agreement_commission.
-- agreement_id сделайте первичным ключом.


DROP TABLE IF EXISTS public.shipping_agreement;

CREATE TABLE public.shipping_agreement (
	agreement_id            int UNIQUE,
	agreement_number        text,
	agreement_rate          NUMERIC(2,2),
	agreement_commission    NUMERIC(2,2),
	PRIMARY KEY (agreement_id)
);

INSERT INTO public.shipping_agreement
            (agreement_id, agreement_number, agreement_rate, agreement_commission)
SELECT
    DISTINCT
        -- пример формата данных shipping.vendor_agreement_description:
        -- "5:vspn-7339:0.04:0.03"
        (regexp_split_to_array(vendor_agreement_description , E'\\:+'))[1]::smallint AS agreement_id,
        (regexp_split_to_array(vendor_agreement_description , E'\\:+'))[2]::text AS agreement_number,
        (regexp_split_to_array(vendor_agreement_description , E'\\:+'))[3]::NUMERIC(2,2) AS agreement_rate,
        (regexp_split_to_array(vendor_agreement_description , E'\\:+'))[4]::NUMERIC(2,2) AS agreement_commission
FROM public.shipping
ORDER BY agreement_id ASC;
