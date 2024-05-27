-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2; 


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions desc; 

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
group by country
order by 2 desc; 

SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
group by YEAR(`date`)
order by 1 desc; 


SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
group by stage
order by 2 desc; 

SELECT company, AVG(percentage_laid_off) 
FROM layoffs_staging2
group by company
order by 2 desc; 

SELECT substring(`date`,1,7) as `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC
;


WITH Rolling_Total AS
(
SELECT substring(`date`,1,7) as `MONTH`, SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) rolling_total
FROM Rolling_Total;



SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
group by company
order by 2 desc; 

SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
group by company, YEAR(`date`)
ORDER BY 3 desc;

WITH Company_Year (company,years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
group by company, YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off desc) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <=5
;









