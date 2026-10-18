\# Olist E-Commerce Sales and Customer Analysis



End-to-end analysis of the Olist Brazilian e-commerce dataset (about 100k

orders, 2016-2018) using Python, MySQL and Power BI.



\## Business questions

1\. Is revenue growing, and when?

2\. Which product categories earn the most?

3\. Do late deliveries lead to worse customer reviews?

4\. How many customers come back?



\## Tools

Python (Pandas), Jupyter Notebook, MySQL 8.0, MySQL Workbench, Power BI Desktop



\## Method

1\. Loaded the 9 CSV files into Pandas and checked missing values and duplicates.

2\. Cleaned the data: converted dates, labeled products with no category as

&#x20;  "unknown", added English category names, and created delivery\_days and

&#x20;  is\_late columns.

3\. Loaded 8 cleaned tables into MySQL (geolocation was not needed).

4\. Answered the questions in SQL using joins, CTEs and window functions

&#x20;  (see sql/analysis.sql).

5\. Built a 3-page Power BI dashboard.



Revenue = sum of item prices (excluding shipping), delivered orders only.



\## Key findings

\- \*\*Revenue:\*\* 13,221,498 across 96,478 delivered orders; average order value

&#x20; 137.04 (currency assumed to be Brazilian reais).

\- \*\*Growth:\*\* Monthly revenue grew from about 111.8k in Jan 2017 to about

&#x20; 648.2k in Oct 2017, peaked in Nov 2017 at 987,765 (+52.4%, likely linked to

&#x20; Black Friday), then stayed between about 826k and 978k through Aug 2018.

\- \*\*Categories:\*\* health\_beauty is the top category by revenue (1,233,132),

&#x20; followed by watches\_gifts and bed\_bath\_table. bed\_bath\_table has the most

&#x20; orders but ranks third in revenue, while watches\_gifts sells higher-priced

&#x20; items.

\- \*\*Delivery and reviews:\*\* About 8.1% of delivered orders (7,826) arrived

&#x20; late. Late orders averaged a review score of 2.57 versus 4.29 for on-time

&#x20; orders (orders with a review only). This shows a strong association, not

&#x20; proof of cause.

\- \*\*Customers:\*\* Only 3.00% of customers (2,801 of 93,358) ordered more than

&#x20; once, so most revenue comes from one-time buyers.



\## Data notes

\- Sep-Dec 2016 has only 1, 265, 0 and 1 delivered orders, so those months are

&#x20; excluded from the trend. The data ends in Aug 2018.

\- 8 orders marked delivered have no delivery date and were excluded from the

&#x20; delivery analysis.

\- Review scores are averaged per order, because some orders have more than

&#x20; one review.



\## Dashboard

!\[Overview](images/overview.png)

!\[Products](images/products.png)

!\[Delivery and reviews](images/delivery\_reviews.png)



\## Files

\- notebooks/olist\_cleaning.ipynb: cleaning and loading

\- sql/analysis.sql: SQL queries

\- notes.md: project notes and decisions



\## Data source

Brazilian E-Commerce Public Dataset by Olist, on Kaggle.

