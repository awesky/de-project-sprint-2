-- 1. Создайте справочник стоимости доставки в страны shipping_country_rates из данных,
-- указанных в shipping_country и shipping_country_base_rate,
-- сделайте первичный ключ таблицы — серийный id, то есть серийный идентификатор каждой строчки.
-- Важно дать серийному ключу имя «id».
-- Справочник должен состоять из уникальных пар полей из таблицы shipping.


DROP TABLE IF EXISTS public.shipping_country_rates;

CREATE TABLE public.shipping_country_rates (
	id                          serial,
    shipping_country            text,
    shipping_country_base_rate  NUMERIC(2,2),
	PRIMARY KEY (id)
);

INSERT INTO public.shipping_country_rates
            (shipping_country, shipping_country_base_rate )
SELECT
	DISTINCT shipping_country, shipping_country_base_rate 
FROM public.shipping
ORDER BY shipping_country_base_rate ASC;