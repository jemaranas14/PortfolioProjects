-- Data Cleaning 

SELECT * 
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data 
-- 3. Null Values or Blank Values 
-- 4. Remove Any Columns  or rows

-- STAGING
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging 
Select *
from layoffs
;


SELECT *,
row_number() OVER(partition by company, industry, percentage_laid_off, 'date') row_num
FROM layoffs_staging;


-- CTE 
WITH duplicate_cte AS
(
SELECT *,
row_number() OVER(partition by company, location, industry, percentage_laid_off, 'date', stage, country, funds_raised_millions) row_num
FROM layoffs_staging
)
Select * 
from duplicate_cte 
where row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';


WITH duplicate_cte AS
(
SELECT *,
row_number() OVER(partition by company, location, industry, percentage_laid_off, 'date', stage, country, funds_raised_millions) row_num
FROM layoffs_staging
)
DELETE 
from duplicate_cte 
where row_num > 1;


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
row_number() OVER(partition by company, location, industry, percentage_laid_off, 'date', stage, country, funds_raised_millions) row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1 ;


DELETE 
FROM layoffs_staging2
WHERE row_num > 1 ;

-- Standarizing data 

SELECT company, Trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
Set company = Trim(company);

SELECT DISTINCT industry
FROM layoffs_staging2
;

UPDATE layoffs_staging2 
SET INDUSTRY = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT distinct country, TRIM(trailing '.' from country)
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2 
Set country = 'United States'
WHERE country like 'United State%';

SELECT  `date`
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

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
where company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	on t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	on t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging2 
set industry = NULL
where industry = ''
;


select *
from layoffs_staging2
where company = "Bally's Interactive"
;


SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;


SELECT * 
FROM layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

