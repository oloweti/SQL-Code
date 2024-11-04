--A glance at the dataset
SELECT *
FROM portfolioproject..Layoffs_staging


=================================================================================
--List of cleaning task to this dataset
--1. Remove Duplicates
--2. Standardize the Data
--3. Null Values or Blank values
--4. Remove any Columns not needed

=====================================================================================
 ----------REMOVE DUPLICATE---------
-- Identifying duplicates using CTE and query off temp table
WITH CTE_Duplicate AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, date, stage, country,funds_raised_millions ORDER BY company) AS number_count
 FROM portfolioproject..Layoffs_staging
 )
 SELECT *
 FROM CTE_Duplicate
 WHERE number_count > 1

--Delete duplicate
WITH CTE_Duplicate AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, date, stage, country,funds_raised_millions ORDER BY company) AS number_count
 FROM portfolioproject..Layoffs_staging
 )
 DELETE
 FROM CTE_Duplicate
 WHERE number_count > 1


--Update "CTE_Duplicate" clean data to newly created table "Layoffs_new"
WITH CTE_Duplicate AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, date, stage, country,funds_raised_millions ORDER BY company) AS number_count
 FROM portfolioproject..Layoffs_staging
 )
INSERT portfolioproject..Layoffs_new
SELECT *
FROM CTE_Duplicate


===========================================================================================
---------STANDARDIZE THE DATA---------------
--Standardizing data. The "company"column was trimmed here and update in the table "layoffs_new". 
SELECT company, TRIM(company) AS company_trim
FROM portfolioproject..Layoffs_new

--Update column "company" to Trimmed "company"
UPDATE portfolioproject..Layoffs_new
SET company = TRIM(company)

--Standardaized every column's value that needs to be standardized
SELECT *
FROM portfolioproject..Layoffs_new
WHERE industry LIKE 'crypto%'

UPDATE portfolioproject..Layoffs_new
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%'

-- --Standardaized "United States" in column "country"
SELECT DISTINCT country
FROM portfolioproject..Layoffs_new
ORDER BY country ASC

UPDATE portfolioproject..Layoffs_new
SET country = 'United States'
WHERE country LIKE 'United States%'

==========================================================================================

--Date conversion. 
--The original column "date" is now deleted from the data after conversion
SELECT *, FORMAT(date,'yyyy-MM-dd') AS date_formated
FROM portfolioproject..Layoffs_new

--Could not update table upfront in SQL server, so added a column first then update the column
ALTER TABLE portfolioproject..Layoffs_new
ADD date_formated date

--update table with new column
UPDATE portfolioproject..Layoffs_new
SET date_formated = FORMAT(date,'yyyy-MM-dd')


--Delete unwanted "date" column
ALTER TABLE portfolioproject..Layoffs_new
DROP COLUMN date 

======================================================================================================

 --Null Values or Blank values
 -- change null value to 0
UPDATE portfolioproject..Layoffs_new
SET percentage_laid_off =  0
WHERE  percentage_laid_off LIKE '%Null%'


-- Capturing where this two columns below have "no data"
SELECT *
FROM portfolioproject..Layoffs_new
WHERE percentage_laid_off = '0' 
AND
total_laid_off IS NULL 


--Deleted where "percentage_laid_off" and total_laid_off" have no data
DELETE 
FROM portfolioproject..Layoffs_new
WHERE percentage_laid_off = '0' 
AND
total_laid_off IS NULL 

========================================================================================
--Delete column "number_count" that was used to identify duplicate (No longer needed)
ALTER TABLE portfolioproject..Layoffs_new
DROP COLUMN number_count


==================================================================================
--Replacing the remainder of "Null" in each columns with 0 to make it ready for analysis
UPDATE portfolioproject..Layoffs_new
SET funds_raised_millions =  0
WHERE  funds_raised_millions IS Null
OR company IS Null
OR location IS Null
OR industry IS Null
OR total_laid_off IS Null
OR stage IS Null
OR country IS Null
OR percentage_laid_off IS Null



