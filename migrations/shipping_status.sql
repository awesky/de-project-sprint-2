-- 5. Создайте таблицу статусов о доставке shipping_status
-- и включите туда информацию из лога shipping (status , state).
-- Добавьте туда вычислимую информацию по фактическому времени доставки
-- shipping_start_fact_datetime, shipping_end_fact_datetime.
-- Отразите для каждого уникального shipping_id его итоговое состояние доставки.


DROP TABLE IF EXISTS public.shipping_status;

CREATE TABLE public.shipping_status (
	shipping_id                     int,
	status                          text,
	state                           text,
	shipping_start_fact_datetime    TIMESTAMP,
	shipping_end_fact_datetime      TIMESTAMP,
	PRIMARY KEY (shipping_id)
);

INSERT INTO public.shipping_status 
            (shipping_id,status,state,shipping_start_fact_datetime,shipping_end_fact_datetime)

SELECT
    shippings.shipping_id,
	shippings.status,
	shippings.state,
	statuses.shipping_start_fact_datetime,
	statuses.shipping_end_fact_datetime

FROM public.shipping AS shippings
    INNER JOIN (
        SELECT 
            shipping_id,
            MAX(state_datetime) AS max_state_datetime,
            MIN(CASE WHEN state = 'booked' THEN state_datetime END) AS shipping_start_fact_datetime,
            MIN(CASE WHEN state = 'recieved' THEN state_datetime END) AS shipping_end_fact_datetime
        FROM public.shipping
        GROUP BY shipping_id
        ) AS statuses
    ON shippings.shipping_id = statuses.shipping_id AND shippings.state_datetime = statuses.max_state_datetime

ORDER BY shipping_id;
