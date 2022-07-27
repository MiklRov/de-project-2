# Проект 2
Опишите здесь поэтапно ход решения задачи. Вы можете ориентироваться на тот план выполнения проекта, который мы предлагаем в инструкции на платформе.


### 0. Создание исходной таблицы `Shipping`

### 1. Создание таблицы `shipping_country`
    Создаём справочник стоимости доставки в страны из данных, указанных в shipping_country и shipping_country_base_rate

### 2. Создание таблицы `shipping_agreement`
    Создаём справочник тарифов доставки вендора по договору из данных строки vendor_agreement_description

### 3. Создание таблицы `shipping_transfer`
    Создаём справочник о типах доставки из строки shipping_transfer_description

### 4. Создание таблицы `shipping_info`
    Создаём таблицу shipping_info с уникальными доставками shippingid и связываем её с созданными справочниками shipping_country_rates, shipping_agreement, shipping_transfer и константной информацией о доставке shipping_plan_datetime , payment_amount , vendorid 

### 5. Создание таблицы `shipping_status`
    Создаём таблицу статусов о доставке shipping_status и включаем туда информацию из лога shipping (status , state). Добавляем туда вычислимую информацию по фактическому времени доставки shipping_start_fact_datetime, shipping_end_fact_datetime . Отражаем для каждого уникального shippingid его итоговое состояние доставки

### 6. Создание представления `shipping_datamart`
    Создаём представление shipping_datamart на основании готовых таблиц для аналитики и включаем в него:
shippingid
vendorid
transfer_type — тип доставки из таблицы shipping_transfer
full_day_at_shipping — количество полных дней, в течение которых длилась доставка. Высчитывается как:shipping_end_fact_datetime-shipping_start_fact_datetime.
is_delay — статус, показывающий просрочена ли доставка. Высчитывается как:shipping_end_fact_datetime >> shipping_plan_datetime → 1 ; 0
is_shipping_finish — статус, показывающий, что доставка завершена. Если финальный status = finished → 1; 0
delay_day_at_shipping — количество дней, на которые была просрочена доставка. Высчитыается как: shipping_end_fact_datetime >> shipping_end_plan_datetime → shipping_end_fact_datetime -− shipping_plan_datetime ; 0).
payment_amount — сумма платежа пользователя
vat — итоговый налог на доставку. Высчитывается как: payment_amount *∗ ( shipping_country_base_rate ++ agreement_rate ++ shipping_transfer_rate) .
profit — итоговый доход компании с доставки. Высчитывается как: payment_amount*∗ agreement_commission.

