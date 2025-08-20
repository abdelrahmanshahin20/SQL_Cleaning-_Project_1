# 📊 Global Layoffs Analysis: SQL Data Cleaning and EDA

## 📝 Overview
This repository showcases my SQL data cleaning and exploratory data analysis (EDA) project, **"Global Layoffs Analysis,"** completed as part of Alex The Analyst’s Data Analytics Bootcamp. The project involves transforming raw global layoffs data from the `layoffs.csv` dataset into a clean, analysis-ready format using MySQL, followed by insightful EDA to uncover workforce trends. The dataset includes layoff records from prominent companies such as Atlassian, Airbnb, and Meta, spanning various industries, locations, and funding details.

## 🎯 Project Objectives
- ✅ Clean raw data by addressing duplicates, inconsistencies, and null values to ensure data integrity.  
- ✅ Standardize data formats and correct errors for consistency across columns.  
- ✅ Conduct EDA to extract meaningful insights, including top companies by layoffs, monthly trends, and yearly rankings.  
- ✅ Demonstrate proficiency in SQL techniques, including CTEs, joins, window functions, and aggregate queries.  

## 📂 Dataset
**Source:** `layoffs.csv` (included in the repository)  
**Description:** Contains global layoff data with columns for company, location, industry, total laid off, percentage laid off, date, stage, country, and funds raised (in millions).  

### 🔑 Key Fields
- **company:** Name of the company  
- **location:** City or region of the company  
- **industry:** Industry sector (e.g., Crypto, Healthcare)  
- **total_laid_off:** Number of employees laid off  
- **percentage_laid_off:** Proportion of workforce laid off  
- **date:** Date of layoff event  
- **stage:** Company funding stage (e.g., Series A, Post-IPO)  
- **country:** Country of the company  
- **funds_raised_millions:** Funds raised by the company (in USD millions)  

## 🛠️ Methodology
The project follows a structured data cleaning and analysis pipeline in MySQL, detailed as follows:

### 1️⃣ Data Cleaning
- **Staging Table Creation:** Established staging tables to preserve raw data and facilitate cleaning processes.  
- **Duplicate Removal:** Utilized `ROW_NUMBER()` with `PARTITION BY` on key columns (e.g., company, location, industry) to identify and eliminate duplicates (see *Image 1* for the initial dataset and *Image 2* for the duplicate removal query).  
- **Data Standardization:**  
  - Removed whitespace from company using `TRIM()`.  
  - Unified inconsistent industry names (e.g., 'Crypto Currency' to 'Crypto') with `UPDATE` and `LIKE`.  
  - Corrected country name inconsistencies (e.g., 'United States.' to 'United States').  
  - Converted date from text to `DATE` format using `STR_TO_DATE` and adjusted the column type with `ALTER TABLE`.  

- **Null and Blank Handling:**  
  - Populated missing industry values using self-joins based on matching company names.  
  - Removed rows where both `total_laid_off` and `percentage_laid_off` were null to enhance data usability.  

- **Column Removal:** Dropped the temporary `row_num` column used for duplicate detection.  

### 2️⃣ Exploratory Data Analysis (EDA)
- 📌 Identified maximum layoffs and companies with 100% workforce reductions (see *Image 3* for top 10 companies by total layoffs).  
- 📌 Calculated total layoffs by company and year using `GROUP BY`.  
- 📌 Generated monthly rolling totals with `SUM() OVER` for temporal trends.  
- 📌 Ranked top 5 companies by layoffs per year using `DENSE_RANK()` (see *Image 4* for the ranking query and *Image 5* for results).  
- 📌 Analyzed relationships between layoffs and funds raised for key companies (e.g., Meta).  

## 📁 Files
- 📄 **My Data Cleaning Project.sql:** The main SQL script containing all cleaning and EDA queries.  
- 📄 **layoffs.csv:** The raw dataset used for the project.  
- 📄 **My work.sql:** Additional SQL practice queries from the bootcamp, covering string functions, CASE statements, CTEs, temporary tables, stored procedures, triggers, and events (included for reference).  
- 🖼️ **Images:** Screenshots illustrating key steps and results (Image 1, Image 2, Image 3, Image 4, Image 5, Image 6).  

## ⚙️ Tools and Technologies
- 🖥️ **MySQL Workbench:** Used for writing and executing SQL queries.  
- 🗄️ **SQL:** Core language for data cleaning and analysis (CTEs, joins, window functions, aggregates).  
- 🌐 **GitHub:** For version control and project sharing.  

## 🚀 Setup and Usage
1. **Clone the Repository:** Download or clone the repository to your local machine.  
2. **Set Up MySQL:** Install MySQL and MySQL Workbench, then import the `layoffs.csv` dataset into a MySQL database (e.g., `world_layoffs` schema).  
3. **Run the SQL Script:** Open `My Data Cleaning Project.sql` in MySQL Workbench and execute the script to perform data cleaning and EDA.  
4. **Explore Results:** Review the query outputs for cleaned data and EDA insights, utilizing the included images for reference.  

## 📈 Key Insights
- **Largest Layoffs:** Identified companies with 100% workforce reductions, often linked to specific funding stages.  
- **Industry Trends:** Crypto and Tech sectors exhibited significant layoffs during certain periods.  
- **Temporal Patterns:** Monthly rolling totals highlighted spikes in layoffs, notably in early 2023.  
- **Top Companies:** Ranked companies like Twitter and Yahoo among the highest for layoffs in specific years.  

## 🙏 Acknowledgments
A heartfelt thank you to Alex The Analyst for the exceptional guidance and structured learning provided through the Data Analytics Bootcamp. This project was inspired by the bootcamp’s emphasis on real-world data challenges and SQL best practices.  

## 🔮 Future Improvements
- 📊 Integrate visualization tools (e.g., Tableau, Power BI) to create interactive dashboards for layoff trends.  
- 📊 Expand EDA to include statistical correlations between layoffs and funds raised.  
- ⚡ Automate the cleaning process using stored procedures or Python scripts.  

## 📬 Contact
I welcome questions, feedback, or collaboration opportunities:  
- **GitHub:**  
- **LinkedIn:**  
- **Email:**  

## 🖼️ Images
- **Initial dataset view before cleaning:**   
- **Duplicate removal query execution:**   
- **Top 10 companies by total layoffs:**    
- **Ranking query for top 5 companies per year:**   
- **Results of the ranking query:**    
- **Final cleaned dataset view:**     

---

**📜 License:** This project is intended solely for demonstration purposes and should not be reused. See the LICENSE file for details.
  

📈 **Happy Analyzing!**
