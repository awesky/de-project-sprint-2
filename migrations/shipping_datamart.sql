-- 6. Создайте представление shipping_datamart на основании готовых таблиц для аналитики и включите в него:
-- shipping_id;
-- vendor_id;
-- transfer_type — тип доставки из таблицы shipping_transfer;
-- full_day_at_shipping — количество полных дней, в течение которых длилась доставка
-- (высчитывается так: shipping_end_fact_datetime − shipping_start_fact_datetime);
-- is_delay — статус, показывающий просрочена ли доставка
-- (высчитывается так: shipping_end_fact_datetime > shipping_plan_datetime → 1; 0);
-- is_shipping_finish — статус, показывающий, что доставка завершена
-- (если финальный status = finished → 1; 0);
-- delay_day_at_shipping — количество дней, на которые была просрочена доставка
-- (высчитывается как: shipping_end_fact_datetime > shipping_plan_datetime →
-- shipping_end_fact_datetime - shipping_plan_datetime; 0);
-- payment_amount — сумма платежа пользователя;
-- vat — итоговый налог на доставку
-- (высчитывается так: payment_amount * (shipping_country_base_rate + agreement_rate + shipping_transfer_rate);
-- profit — итоговый доход компании с доставки;
-- (высчитывается как: payment_amount ∗ agreement_commission).


CREATE OR REPLACE VIEW shipping_datamart AS 
    SELECT 
        info.shipping_id,
        info.vendor_id,
        info.shipping_transfer_id as transfer_type,
        date_trunc('day', shipping_end_fact_datetime - shipping_start_fact_datetime) AS full_day_at_shipping,
        CASE 	
            WHEN shipping_end_fact_datetime > shipping_plan_datetime
            THEN shipping_end_fact_datetime > shipping_plan_datetime
            ELSE '0'
        END AS is_delay,
        status = 'finished' AS is_shipping_finish, 
        CASE 	
            WHEN shipping_end_fact_datetime > shipping_plan_datetime
            THEN date_trunc('day', shipping_end_fact_datetime - shipping_plan_datetime)
            ELSE '0'
        END AS delay_day_at_shipping,	
        info.payment_amount,
        info.payment_amount * (shipping_country_base_rate + agreement_rate + shipping_transfer_rate) AS vat,
        info.payment_amount * agreements.agreement_commission AS profit
    
    FROM shipping_info AS info
        LEFT JOIN shipping_status AS statuses ON info.shipping_id = statuses.shipping_id
        LEFT JOIN shipping_country_rates AS rates ON info.shipping_country_rate_id = rates.id	
        LEFT JOIN shipping_agreement AS agreements ON info.shipping_agreement_id = agreements.agreement_id	
        LEFT JOIN shipping_transfer AS transfers ON info.shipping_transfer_id = transfers.id;
