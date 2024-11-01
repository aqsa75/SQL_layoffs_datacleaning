select *
from layoffs

-- 1. remove duplicates
-- 2. Standardize the Date
-- 3. Null values or blank values
-- 4. remove any columns 


SELECT *
INTO layoffs_staging
FROM layoffs;

--window function in SQL Server that assigns a unique sequential integer to each row within a partition of a result set.
SELECT *,
       ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date' ORDER BY (SELECT NULL)) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [date], stage, country, funds_raised_millions 
                              ORDER BY (SELECT NULL)) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE [dbo].[layoffs_staging2] (
    [company]               VARCHAR (50) NOT NULL,
    [location]              VARCHAR (50) NOT NULL,
    [industry]              VARCHAR (50) NULL,
    [total_laid_off]        VARCHAR (50) NULL,
    [percentage_laid_off]   VARCHAR (50) NULL,
    [date]                  VARCHAR (50) NOT NULL,
    [stage]                 VARCHAR (50) NOT NULL,
    [country]               VARCHAR (50) NOT NULL,
    [funds_raised_millions] VARCHAR (50) NULL,
    [row_num] VARCHAR (50) NULL
);


insert into layoffs_staging2
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [date], stage, country, funds_raised_millions 
                              ORDER BY (SELECT NULL)) AS row_num
    FROM layoffs_staging

select*
from layoffs_staging2
where row_num > 1;

delete
from layoffs_staging2
where row_num > 1;

-- Standardizing Data

select company, (trim(company))
from layoffs_staging2

UPDATE layoffs_staging2
set company = TRIM(company)

select distinct(industry)
from layoffs_staging2

select *
from layoffs_staging2
where industry LIKE 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry LIKE 'Crypto%'

SELECT DISTINCT country,
       CASE 
           WHEN RIGHT(country, 1) = '.' THEN LEFT(country, LEN(country) - 1)
           ELSE country
       END AS trimmed_country
FROM layoffs_staging2
ORDER BY country;

--select Distinct(country), trim(trailing '.' FROM country)
--from layoffs_staging2
--ORDER BY 1; error

--update layoffs_staging2
--set country = ''
--where country LIKe 'United States%'

--in mysql:
select date, str_to_date(date, '%m/%d/%Y')
 from layoffs_staging2

SELECT [date], 
       TRY_CONVERT(DATE, [date], 101) AS converted_date
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET [date] = TRY_CONVERT(DATE, [date], 101)
WHERE TRY_CONVERT(DATE, [date], 101) IS NOT NULL;

SELECT [date]
FROM layoffs_staging2
WHERE TRY_CONVERT(DATE, [date], 101) IS NULL
AND [date] IS NOT NULL; -- Filter out NULL values if necessary


select *
from layoffs_staging2
where total_laid_off LIKE 'NULL%' AND percentage_laid_off LIKE 'NULL%'

select *
from layoffs_staging2
where industry IS NULL OR industry = '' OR industry = 'NULL';


update layoffs_staging2
set industry = NULL
where industry = ' ' OR industry = 'NULL'

-- only had one layoff so couldnt populate it with an industry type
select *
from layoffs_staging2
where company LIKE 'Bally%'


select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
where(t1.industry is NULL )
AND t2.industry is NOT NULL

UPDATE t1
SET t1.industry = t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

--removing columns and rows 


select *
from layoffs_staging2
where total_laid_off LIKE 'NULL%' AND percentage_laid_off LIKE 'NULL%'


delete
from layoffs_staging2
where total_laid_off LIKE 'NULL%' AND percentage_laid_off LIKE 'NULL%'

select *
from layoffs_staging2

alter table layoffs_staging2
drop column row_num

