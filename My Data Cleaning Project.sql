-- Data Cleaning project 

Select *
from world_layoffs.layoffs;

-- Steps to Follow 
-- 1. Remove duplicates
-- 2. Standradized the data
-- 3. Null value or blank values
-- 4. remove any columns 

select * from layoffs;

-- first we need to make a staging table because we don't want to 
-- use the origianl data we leave as a beckup data

CREATE TABLE layoffs_staging
like layoffs;
select * from layoffs_staging;

INSERT layoffs_staging 
select * from layoffs; 

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;
-- here we made a row number to use as a index to get the duplicated values

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1; 
/*
 HERE this code should remove the duplicate values but in mySQL it cosiders it as update
 and this because CTEs is not the real database it just like a temmporary result. 
 in other words we can't do this we make a new database from the code inside the CTEs
 the new database should contain the new cloumn which is row_num a INT
 and then deleting the duplicate values.
*/




CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1; 


SELECT *
FROM layoffs_staging2;
-- if u notice we have deleted the duplicated values


-- Step 2 Standardizing 

SELECT *
FROM layoffs_staging2;

SELECT DISTINCT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company); -- remove unnecessary speaces 

SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1; -- if u see we will found that htere are crypto and crypto currency

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- this query turned crypto currency to crypto.

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1; -- i can't see any problem with this cloumn right now


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
 -- there are 2 united states and one of them ends with .
 
SELECT country
FROM layoffs_staging2
WHERE country LIKE '%.' ;
-- we find 4 united states with . at the end

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE '%.'; 
-- this query fixed the . problem

SELECT `date`, STR_TO_DATE (`date`,'%m/%d/%Y')
FROM layoffs_staging2;

-- this change the format of  text to date 

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

 ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;
-- this query change the type of column' date to date.

-- Step 2 of Standardization deal with null and blank values


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = "Airbnb";

/*look when can see the blank values in the industry column and see is this company
exist again in the table and see what the industry of this company and make a update
statemt and repeat this 4 time of the rest manually put this sometimes is not practical
or avaliable so here we are going to use joins
*/

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE t1.industry IS NULL 
	OR t2.industry IS NOT NULL;
    
-- to make the previous query works well we need a update statement to make all 
-- the ' ' equals to null 

UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
-- it works but if u see there one company is still null and this because we
-- didn't knoe the industry because there is only one company

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
/* if u see here there a lot null in the two columns and this is not good 
because there is not other way to know and this of course make these nulls 
useless and not likely to be used so i decieded to delete it*/

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- know after cleaning we can remove the row_num columns if we want

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;

-- Exploratory Data Analysis (EDA)

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

WITH Rolliong_Total AS
(
SELECT SUBSTRING(`date`, 1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, total_off
, SUM(total_off) OVER (ORDER BY `Month`) AS rolling_total
FROM Rolliong_Total;

SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company , year(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , year(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years , total_laid_off) AS
(
SELECT company , year(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , year(`date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking 
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5;


SELECT * 
FROM layoffs_staging2;

SELECT company, SUM(total_laid_off) AS total_laid_off,
SUM(funds_raised_millions) AS funds_raised_millions
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
limit 10 ;


SELECT company , total_laid_off,funds_raised_millions, `date`
FROM layoffs_staging2
WHERE company = "Meta"
ORDER BY `date` ASC ;

