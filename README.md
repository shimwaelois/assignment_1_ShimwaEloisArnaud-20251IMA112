# PL/SQL Assignment One: Sunrise Supermarket

- **Student name:** Shimwa Elois Arnaud
- **Student ID:** 20251IMA112
- **DBMS used:** (Oracle FreeSQL (Oracle Database 26ai))
- **Repo name:** `assignment_1_Shimwa_Elois_Arnaud-20251IMA112`

## Business scenario
Sunrise Supermarket sells products to customers, who place orders containing one or more items. Management wants to know who its customers are, what they buy, and how sales trend over time. The database has four tables: `customers`, `products`, `orders`, `order_items`. Sample data: 6 customers (one has never ordered), 8 products in 4 categories (Grocery, Dairy, Beverages, Household), 15 orders (Jan to May 2026) and 25 order items.

## How to run
1. Run `01_schema_and_data.sql` (creates tables and inserts data).
2. Run `02_queries.sql` (Q1 to Q8). Run each query separately and take a screenshot.

## Queries

> Full SQL for every query is in `02_queries.sql`. Paste your screenshots under each question.

### Q1. Orders with customer name, city, date (INNER JOIN)
Links each order to the customer who placed it. Only orders with a matching customer appear.
![Q1A](screenshots/Q1A.png)

![Q1B](screenshots/Q1B.png)
### Q2. Order items with product details (JOIN)
Shows what was bought in each order line, with product name, category, price and quantity.
![Q2A](screenshots/Q2A.png)

![Q2B](screenshots/Q2B.png)

![Q2C](screenshots/Q2C.png)

### Q3. All customers and their orders (LEFT JOIN)
Keeps every customer, even those with no orders. **Frank Niyonzima** appears with NULL order columns because he has never ordered.
![Q3A](screenshots/Q3A.png)

![Q3B](screenshots/Q3B.png)
### Q4. Customers who spent above average (CTE)
A CTE (`customer_totals`) computes each customer's total (quantity × price). The main query keeps those above the average of those totals.

| Customer | Total spent |
|---|---|
| Alice Uwase | 57,300 |
| Brian Mugisha | 43,000 |

Average customer spend = 37,720 (among customers who ordered).
![Q4](screenshots/Q4.png)

### Q5. Rank customers by total spent (RANK)
Uses `RANK() OVER (ORDER BY total_spent DESC)` on the CTE totals.

| Rank | Customer | Total spent |
|---|---|---|
| 1 | Alice Uwase | 57,300 |
| 2 | Brian Mugisha | 43,000 |
| 3 | David Habimana | 36,700 |
| 4 | Esther Mukamana | 27,500 |
| 5 | Chantal Ingabire | 24,100 |

![Q5](screenshots/Q5.png)

### Q6. Number each customer's orders (ROW_NUMBER)
`ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)` restarts at 1 for each customer, giving their 1st, 2nd, 3rd order and so on.
![Q6A](screenshots/Q6A.png)

![Q6B](screenshots/Q6B.png)
### Q7. Running total of revenue (SUM OVER)
Order revenue is computed in a CTE, then `SUM(order_total) OVER (ORDER BY order_date, order_id)` accumulates it. Revenue grows from 22,800 (5 Jan) to **188,600** by 6 May 2026.
![Q7A](screenshots/Q7A.png)

![Q7B](screenshots/Q7B.png)

### Q8. Days between consecutive orders (LAG)
`LAG(order_date)` per customer gives the previous order date; subtracting it from the current date gives the gap in days. First orders are excluded, so only customers with 2+ orders appear.

| Customer | Order | Days since previous |
|---|---|---|
| Alice Uwase | 3 | 15 |
| Alice Uwase | 7 | 36 |
| Alice Uwase | 11 | 33 |
| Brian Mugisha | 6 | 38 |
| Brian Mugisha | 12 | 49 |
| Chantal Ingabire | 9 | 38 |
| Chantal Ingabire | 14 | 41 |
| David Habimana | 10 | 36 |
| David Habimana | 15 | 49 |
| Esther Mukamana | 13 | 42 |

![Q8](screenshots/Q8.png)

## Business interpretation
- **Customers:** Alice (57,300) and Brian (43,000) are the top spenders and the only two above the 37,720 average. Alice is also the most frequent buyer (4 orders). Together they account for over half of total revenue (188,600).
- **Inactive customer:** Frank has never ordered. He is a target for a welcome offer or promotion.
- **Sales trend:** Revenue accumulates steadily, but individual orders are getting smaller: the largest orders were in January and February, while April and May orders are around 6,500 to 9,000.
- **Purchase frequency:** Most repeat customers reorder every 5 to 7 weeks, and the gaps are lengthening (Alice: 15, 36, 33 days; Brian: 38, 49; David: 36, 49). Loyalty offers or reminders could shorten these gaps.

## Challenges and solutions
- **Customers with no orders:** an INNER JOIN would hide Frank, so a LEFT JOIN was used in Q3.
- **Average spend:** computing the average directly over a grouped query is not allowed, so a CTE calculates per-customer totals first and the main query compares against `AVG(total_spent)`.
- **Same-day ordering:** window functions use `order_id` as a tie-breaker so results are deterministic.
- **Date subtraction:** in Oracle, subtracting two DATE values returns days, so no extra function is needed for Q8.
