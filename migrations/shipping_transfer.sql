-- 3. Создайте справочник о типах доставки shipping_transfer
-- из строки shipping_transfer_description
-- через разделитель «:» (двоеточие без кавычек). 
--
-- Названия полей: 
-- transfer_type,
-- transfer_model,
-- shipping_transfer_rate .
-- Первичным ключом таблицы сделайте серийный id.


DROP TABLE IF EXISTS public.shipping_transfer;

CREATE TABLE public.shipping_transfer (
	id                      serial,
	transfer_type           text,
	transfer_model          text,
	shipping_transfer_rate  NUMERIC(3,3),
	PRIMARY KEY (id)
);

INSERT INTO public.shipping_transfer
            (transfer_type, transfer_model, shipping_transfer_rate)
SELECT
    DISTINCT
    -- пример формата данных shipping.shipping_transfer_description:
    -- "1p:airplane"
	(regexp_split_to_array(shipping_transfer_description , E'\\:+'))[1] AS transfer_type,
    (regexp_split_to_array(shipping_transfer_description , E'\\:+'))[2] AS transfer_model,
	shipping_transfer_rate
FROM public.shipping;
