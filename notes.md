# Olist E-Commerce Analysis: Project Notes

## Goal
Analyze the Olist Brazilian e-commerce dataset (Kaggle) to answer four
business questions:
1. Is revenue growing, and when?
2. Which product categories earn the most?
3. Do late deliveries lead to worse customer reviews?
4. How many customers come back (repeat-customer rate)?

## Tools
Python (Pandas), Jupyter Notebook, MySQL 8.0 (local), MySQL Workbench,
Power BI Desktop

## Step 1: Data loaded
- Source: Brazilian E-Commerce Public Dataset by Olist (Kaggle), 9 CSV files
- Loaded all files into Python (Pandas) from the data/ folder

## Step 2: Data quality check
Row counts: customers 99,441 | orders 99,441 | order_items 112,650 |
order_payments 103,886 | order_reviews 99,224 | products 32,951 |
sellers 3,095 | geolocation 1,000,163 | category translation 71

Missing values:
- orders: order_approved_at (160), order_delivered_carrier_date (1,783),
  order_delivered_customer_date (2,965)
- order_reviews: review_comment_title (87,656), review_comment_message (58,247)
- products: category and 3 related columns (610 each), weight/size (2 each)
- customers, order_items, order_payments, sellers: none

Duplicates: geolocation has 261,831 duplicate rows; all other tables have none

## Step 3: Cleaning decisions
- Done: checked order_status. 96,478 of 99,441 orders are delivered; the other
  2,963 are shipped (1,107), canceled (625), unavailable (609), invoiced (314),
  processing (301), created (5) or approved (2)
- Done: 2,957 of the 2,965 missing delivery dates belong to orders that were
  not delivered, so they are expected, not errors. 8 orders marked delivered
  have no delivery date; excluded from the delivery-time analysis
- Decision: revenue analysis uses delivered orders only
- Decision: did not fill in missing delivery dates
- Done: converted the 5 date columns in orders to datetime format
- Done: created delivery_days and is_late for delivered orders with a delivery
  date (96,470 orders)
- Finding: 7,826 orders (about 8.1%) were delivered late; 88,644 (about 91.9%)
  on time or early
- Finding: median delivery time is 10 days (mean 12.1); max is 209 days, a
  rare outlier I kept
- Done: labeled 610 products with no category as "unknown" and joined English
  category names from the translation table
- Done: 13 products (portateis_cozinha_e_preparadores_de_alimentos: 10,
  pc_gamer: 3) were missing from the translation table; added English names
  manually
- Decision: left the 2 products with missing weight/size as they are, since
  my analysis does not use product dimensions
- Decision: left review comment title/message empty, because comments are
  optional and I analyze review scores, not text
- Decision: skipped the geolocation table (not needed for my questions)

## Step 4: Loaded into MySQL
- Done: loaded 8 cleaned tables into a local MySQL database (olist);
  geolocation not loaded
- Verified: orders has 99,441 rows and 96,478 delivered orders in MySQL,
  matching the Python results
- The MySQL password is entered with getpass, so it is not stored in the
  notebook

## Step 5: SQL analysis (queries saved in sql/analysis.sql)
Revenue = sum of item prices (price column in order_items), delivered orders
only, excluding shipping (freight_value)

- Query 1, total revenue: 13,221,498.11 from 96,478 delivered orders
  (currency assumed to be Brazilian reais)
- Query 2 and 3, revenue by month and month-over-month growth:
  - Sep-Dec 2016 has only 1, 265, 0 and 1 delivered orders (no delivered
    orders in Nov 2016), so growth percentages for those months and for
    Jan 2017 are meaningless (for example +29,777% and +1,025,573%);
    excluded from trend analysis
  - Monthly revenue grew from about 111.8k (Jan 2017, 750 orders) to about
    648.2k (Oct 2017, 4,478 orders)
  - Nov 2017 is the peak: 987,765.37 (+52.4% vs Oct), likely linked to Black
    Friday; Dec 2017 fell 26.5% to 726,033.19
  - 2018: monthly revenue stayed roughly flat between 826,437 (Feb) and
    977,545 (May); orders were between 6,099 and 7,069 per month
  - Data ends at Aug 2018 (no delivered orders after that); Jan 2017 to
    Aug 2018 is the complete trend period
- Query 4, top 10 categories by revenue (delivered orders):
  health_beauty 1,233,131.72 (8,647 orders), watches_gifts 1,166,176.98
  (5,495), bed_bath_table 1,023,434.76 (9,272), sports_leisure 954,852.55
  (7,530), computers_accessories 888,724.61 (6,530), furniture_decor
  711,927.69 (6,307), housewares 615,628.69 (5,743), cool_stuff 610,204.10
  (3,559), auto 578,966.65 (3,810), then toys
  - Finding: bed_bath_table has the most orders but ranks 3rd in revenue;
    watches_gifts has fewer orders but higher revenue, so it sells
    higher-priced items
  - An order with items from two categories is counted once in each category
- Query 5, delivery vs review score (orders with a review, one score per
  order): on-time or early orders average 4.29 (88,163 orders); late orders
  average 2.57 (7,661 orders), a gap of about 1.72 points
  - Counts are lower than 88,644 / 7,826 because only orders with a review
    are included
  - Finding: late deliveries are strongly associated with lower review
    scores; this shows association, not proof of cause
- Query 6, repeat-customer rate (delivered orders, customers identified by
  customer_unique_id): 93,358 customers, 2,801 repeat customers (3.00%)
  - Finding: only about 3% of customers ordered more than once, so most
    revenue comes from one-time buyers; data covers roughly two years

## Step 6: Power BI dashboard (dashboard/olist_dashboard.pbix)
- Connected Power BI to the local MySQL database (olist) and loaded 5 tables:
  orders, order_items, products, order_reviews, customers
- Relationships: order_items to orders (order_id), order_items to products
  (product_id), order_reviews to orders (order_id), customers to orders
  (customer_id)
- Measures: Total Revenue, Delivered Orders, Avg Order Value, Customers,
  Repeat Customers, Repeat Customer %, Avg Review Score (average of each
  order's own average review score, to match the SQL result)
- Added a Month column and a Delivery Status column (Late / On time) to orders
- Checked Power BI against SQL: Total Revenue 13.22M, Avg Order Value 137.04,
  Repeat Customer % 3.00%, review scores 4.29 (on time) and 2.57 (late)
- Delivered Orders card shows 96K (rounded display of 96,478)
- 3 pages:
  - Overview: 4 KPI cards and monthly revenue chart (filtered to Jan 2017
    onward to exclude the near-empty 2016 months)
  - Products: top 10 categories by revenue
  - Delivery & Reviews: average review score, on time vs late
- Applied a built-in theme and consistent styling across pages

## Final checks before publishing
- Notebook saved and checked that no password is written in any cell
- README.md, screenshots (images/) and this notes file added
- Do not upload the data/ folder or .ipynb_checkpoints to GitHub