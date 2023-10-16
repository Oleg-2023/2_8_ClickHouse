WITH subselect AS (
  SELECT
    order_date,
    category,
    SUM(revenue) OVER (PARTITION BY category ORDER BY order_date) AS cumulative_revenue,
    COUNT(*) OVER (PARTITION BY category ORDER BY order_date) AS cumulative_orders,
    /* Подстраховываемся функцией, которая при делении на 0 возвращает 0 */
    intDivOrZero(cumulative_revenue, cumulative_orders) AS average_check 
  FROM sales
)

SELECT
    order_date,
    category,
    cumulative_revenue,
    cumulative_orders,
    average_check,
    argMax(order_date, average_check) OVER (PARTITION BY category) AS max_avg_check_date,
    MAX(average_check) OVER (PARTITION BY category) AS max_avg_check_value                 
FROM subselect
ORDER BY category, order_date

  