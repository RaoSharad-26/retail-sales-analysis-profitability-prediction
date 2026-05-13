# 🛒 Retail Sales Analysis & Profitability Prediction

> An end-to-end data analytics pipeline combining **Python**, **MySQL**, and **Machine Learning** to uncover business insights and predict order profitability from retail transaction data.

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Dataset](#-dataset)
- [Data Cleaning & Feature Engineering](#-data-cleaning--feature-engineering)
- [SQL-Based Exploratory Data Analysis](#-sql-based-exploratory-data-analysis)
- [Machine Learning – Profitability Prediction](#-machine-learning--profitability-prediction)
- [Key Results](#-key-results)
- [Business Insights](#-business-insights)
- [How to Run](#-how-to-run)
- [Model Serialization](#-model-serialization)

---

## 🔍 Project Overview

This project performs a full-cycle retail analytics workflow on 9,994 US retail orders spanning 2022–2023. The pipeline is structured in three core stages:

1. **Data Cleaning & Feature Engineering** — standardizing the raw dataset and deriving business-relevant metrics
2. **SQL-Based Exploratory Data Analysis** — answering 8 key business questions using MySQL queries with Python visualizations
3. **Machine Learning Profitability Prediction** — binary classification to predict whether an order will be profitable or loss-making

---

## 🛠 Tech Stack

| Layer | Tools |
|---|---|
| Language | Python 3.x |
| Data Manipulation | Pandas, NumPy |
| Database | MySQL, SQLAlchemy, PyMySQL |
| Visualization | Matplotlib, Seaborn |
| Machine Learning | Scikit-learn |
| Model Persistence | Pickle |
| Data Source | Kaggle API |

---

## 📁 Project Structure

retail-sales-analysis/
├── database_schema.sql          # MySQL table creation & schema script
├── orders.csv                   # Raw dataset (downloaded via Kaggle API)
├── README.md                    # Project documentation
└── Retail_Sales_Analysis_and_Profitability_Prediction.ipynb   # Main pipeline (Cleaning, SQL EDA, & ML)

---

## 📦 Dataset

- **Source:** [Kaggle – Retail Orders Dataset](https://www.kaggle.com/datasets/ankitbansal06/retail-orders) by Ankitbansal06
- **License:** CC0-1.0
- **Shape:** 9,994 rows × 16 columns (raw)
- **Coverage:** United States retail orders, 2022–2023

**Raw Columns:**

`Order Id` · `Order Date` · `Ship Mode` · `Segment` · `Country` · `City` · `State` · `Postal Code` · `Region` · `Category` · `Sub Category` · `Product Id` · `cost price` · `List Price` · `Quantity` · `Discount Percent`

---

## 🧹 Data Cleaning & Feature Engineering

### Cleaning Steps

- Treated `"Not Available"` and `"unknown"` as `NaN` during import
- Identified and documented 6 missing values in `Ship Mode`
- Standardized all column names → `lowercase_with_underscores`
- Converted `order_date` from `object` to `datetime64`
- Dropped the `country` column (single unique value: *United States*)
- Removed duplicate rows (none found — final shape: 9,994 × 15)

### Engineered Features

| Feature | Formula |
|---|---|
| `year` | Extracted from `order_date` |
| `month` | Extracted from `order_date` |
| `discount` | `list_price × (discount_percent / 100)` |
| `sales_price` | `list_price − discount` |
| `total_revenue` | `sales_price × quantity` |
| `profit` | `(sales_price − cost_price) × quantity` |

**Final dataset shape after feature engineering:** `9,994 rows × 21 columns`

---

## 🗄 SQL-Based Exploratory Data Analysis

A dedicated SQL DataFrame (`df_sql`) was exported to a **MySQL** database and queried to answer 8 business questions.

### Business Questions Answered

| # | Question | Key Finding |
|---|---|---|
| Q1 | Overall business performance? | Revenue: **$11.08M** · Profit: **$1.04M** · Units Sold: **37,873** |
| Q2 | Which categories generate the most revenue? | **Technology** leads at $3.93M |
| Q3 | Which sub-categories are most profitable? | **Chairs** ($153.9K) and **Phones** ($139.5K) top the list |
| Q4 | Which states generate the highest revenue? | **California** dominates at $2.22M |
| Q5 | Which cities are most profitable? | **New York City** leads at $103.9K profit |
| Q6 | How do discounts affect revenue and profit? | Higher discounts → higher revenue but lower profit |
| Q7 | Which products generate the highest revenue? | `TEC-CO-10004722` tops at $245K |
| Q8 | What is the monthly revenue trend? | Peaks in **Feb 2023** ($731.6K) and **Oct 2022** ($601.7K) |

---

## 🤖 Machine Learning – Profitability Prediction

### Problem Statement

Binary classification: **Will a given retail order be profitable?**

```
Target Variable: is_profitable
  1 → Profitable Order  (profit > 0)
  0 → Loss-Making Order (profit ≤ 0)
```

### Feature Selection

Leakage-prone columns (`profit`, `sales_price`, `discount`, `total_revenue`, `cost_price`, `list_price`) and high-cardinality identifiers (`order_id`, `product_id`, `city`, `postal_code`, `order_date`) were removed.

**Final features (10):**

`ship_mode` · `segment` · `state` · `region` · `category` · `sub_category` · `quantity` · `discount_percent` · `year` · `month`

### Preprocessing Pipeline

```python
ColumnTransformer([
    ('num', StandardScaler(),      numerical_cols),
    ('cat', OneHotEncoder(...),    categorical_cols)
])
```

### Train / Test Split

| Set | Rows |
|---|---|
| Training | 7,995 (80%) |
| Testing | 1,999 (20%) |

Stratified split with `random_state=42`.

---

## 📊 Key Results

### Model Performance Comparison

| Metric | Logistic Regression | Random Forest |
|---|---|---|
| **Accuracy** | **78.09%** | 77.29% |
| **Precision** | **81.21%** | 80.51% |
| **Recall** | **78.10%** | 77.28% |
| **F1 Score** | **79.63%** | 78.86% |

> ✅ **Logistic Regression** outperformed Random Forest marginally across all metrics and is the recommended final model.

### Top 10 Predictive Features (Random Forest)

| Rank | Feature | Importance Score |
|---|---|---|
| 1 | `quantity` | 0.1316 |
| 2 | `month` | 0.1288 |
| 3 | `discount_percent` | 0.0745 |
| 4 | `category_Office Supplies` | 0.0574 |
| 5 | `year` | 0.0352 |
| 6 | `sub_category_Storage` | 0.0318 |
| 7 | `category_Technology` | 0.0277 |
| 8 | `sub_category_Furnishings` | 0.0224 |
| 9 | `ship_mode_Standard Class` | 0.0223 |
| 10 | `segment_Consumer` | 0.0219 |

---

## 💡 Business Insights

- **Technology** is the highest-revenue category — worth prioritizing in promotions and inventory planning
- **Chairs** and **Phones** deliver the strongest profits — protect margins in these sub-categories
- **California**, **New York City**, and **Los Angeles** are the strongest markets — ideal for targeted campaigns
- **Discounts increase revenue but erode profit** — use selectively and strategically
- **Seasonal peaks** observed in February and October — plan staffing and inventory accordingly
- A few products account for a disproportionate share of revenue — strong product concentration risk

---

## 🚀 How to Run

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/retail-sales-analysis.git
cd retail-sales-analysis
```

### 2. Install Dependencies

```bash
pip install pandas numpy matplotlib seaborn scikit-learn sqlalchemy pymysql kaggle
```

### 3. Configure Kaggle API

Place your `kaggle.json` credentials file at `~/.kaggle/kaggle.json`, then:

```bash
kaggle datasets download ankitbansal06/retail-orders -f orders.csv
```

### 4. Configure MySQL

Update the connection string in the notebook:

```python
username = "your_username"
password = "your_password"
host     = "localhost"
port     = "3306"
database = "retail_sales_analysis_project"
```

Create the database in MySQL before running:

```sql
CREATE DATABASE retail_sales_analysis_project;
```

### 5. Run the Notebook

```bash
jupyter notebook retail_sales_analysis.ipynb
```

**Note**: The .pkl model files are not included in this repository due to GitHub size limits. They will be automatically generated and saved to the /models folder when you execute the retail_sales_analysis.ipynb notebook.

---

## 💾 Model Serialization

Both trained pipelines (preprocessing + model) are serialized using Pickle at the end of the analysis pipeline. Once the notebook is run, you can load them for deployment:

```python
# Load saved model
import pickle

with open('logistic_regression_model.pkl', 'rb') as f:
    lr_pipeline = pickle.load(f)

# Predict on new data
prediction = lr_pipeline.predict(new_order_df)
# Output: 1 (Profitable) or 0 (Loss-Making)
```

---

## 📄 License

Dataset licensed under **CC0-1.0** (Public Domain). Project code is open for educational and commercial use.

---

<div align="center">
  <sub>Built with Python · Pandas · MySQL · Scikit-learn</sub>
</div>
