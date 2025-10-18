# Navigating the Future of Online Shopping

## Project Overview
This project analyzes customer, order, product, and seller data from an online retail dataset to uncover key business insights.  
Using **SQL** and **Python**, the analysis focuses on customer behavior, sales performance, and market trends to guide business strategies.

## Objectives
- Extract and analyze e-commerce sales data using SQL and Python.  
- Identify trends in orders, payments, and revenue across time and categories.  
- Measure customer retention and yearly sales growth.  
- Visualize insights through data-driven charts.

## Datasets Used
| Dataset | Description | Key Columns |
|----------|--------------|-------------|
| Customers | Customer information | `customer_id`, `customer_city`, `customer_state` |
| Orders | Order details | `order_id`, `customer_id`, `order_purchase_timestamp` |
| Order Items | Product-level order details | `order_id`, `product_id`, `price`, `freight_value` |
| Payments | Payment information | `order_id`, `payment_type`, `payment_value` |
| Products | Product metadata | `product_id`, `product_category_name`, `product_weight_g` |
| Sellers | Seller information | `seller_id`, `seller_city`, `seller_state` |
| Geolocation | Location coordinates | `geolocation_zip_code_prefix`, `geolocation_city`, `geolocation_state` |

---

## Tools and Technologies
- **Languages:** SQL, Python  
- **Libraries:** Pandas, Matplotlib, Seaborn, PyMySQL  
- **Database:** MySQL  
- **Environment:** Google Colab  
- **Visualization:** Matplotlib & Seaborn  

---

## SQL Analysis Highlights
Key SQL tasks performed:
1. Number of unique cities where customers are located.  
2. Total number of orders per year and per month.  
3. Total sales per product category.  
4. Number of customers per state.  
5. Average number of products per order by city.  
6. Year-over-year (YoY) sales growth.  
7. Retention rate of customers within 6 months.

---

## Python Analysis and Visualization

### 1. Total Sales per Product Category
### 2. Orders per Month in 2017
### 3. Number of Customers per State
### 4. Average Number of Products per Order by Customer City (Top 20)
### 5. Year-over-Year (YoY) Sales Growth

## Key Insights
- Sales increased significantly between 2017 and 2018, showing strong YoY growth.
- Customers are distributed widely, but certain states dominate in order volume.
- Some product categories contribute a major share of total revenue.
- The average number of products per order is higher in urban cities.
- Customer retention within six months remains low, suggesting a need for engagement strategies.

## Conclusion
The project demonstrates an end-to-end data analysis process — from extraction and transformation to visualization and insight generation.
Using SQL and Python, we derived meaningful patterns in customer behavior, product demand, and regional performance that can guide marketing and business strategies.

## Author
Lopita Mishra

    plt.text(v, i, f'{v:,.0f}', va='center')
plt.show()
