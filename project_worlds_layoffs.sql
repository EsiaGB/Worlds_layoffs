SELECT *from layoffs_1;
DESC layoffs_1;

-- creating a copy of the table 

CREATE TABLE world_layoffs
LIKE layoffs_1;

INSERT world_layoffs
SELECT * from layoffs_1;


SELECT *from world_layoffs;

SELECT 
  company, 
  location, 
  total_laid_off,
  industry, 
  `date`, 
  country,
ROW_NUMBER() OVER(PARTITION BY company, 
  location, 
  total_laid_off, 
  `date`, 
  country) as number_rows
FROM 
  world_layoffs;

-- checking duplicates

SELECT 
  company, 
  location, 
  total_laid_off,
  industry, 
  `date`, 
  country,
ROW_NUMBER() OVER(PARTITION BY company, 
  location, 
  total_laid_off, 
  `date`, 
  country) as number_rows
FROM 
  world_layoffs;



SELECT * FROM (
SELECT company, industry,
  location, 
  total_laid_off, 
  percentage_laid_off,
  `date`,
  stage, 
  country,
  funds_raised
ROW_NUMBER() OVER(PARTITION BY company, industry,
  location, 
  total_laid_off, 
  percentage_laid_off,
  `date`,
  stage, 
  country, funds_raised) as number_rows
  FROM world_layoffs) as duplicates
  WHERE number_rows >1;

SELECT * from world_layoffs
WHERE company IN ('Beyond Meat', 'Cazoo')
ORDER BY funds_raised DESC;

ALTER TABLE world_layoffs ADD row_num INT;

SELECT *from world_layoffs;

ALTER TABLE world_layoffs DROP COLUMN row_num;

ALTER TABLE world_layoffs ADD row_num INT;


CREATE TABLE `worlds_layoffs` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised` int,
row_num INT
);

INSERT INTO `worlds_layoffs`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised`,
ROW_NUMBER() OVER(PARTITION BY company, industry,
  location, 
  total_laid_off, 
  percentage_laid_off,
  `date`,
  stage, 
  country, funds_raised) as row_num
  FROM world_layoffs;

SELECT *from worlds_layoffs
WHERE row_num > 1;

-- deleting duplicates

DELETE FROM worlds_layoffs
WHERE row_num >1;

-- checking if duplicated are removed
SELECT *from worlds_layoffs
WHERE row_num BETWEEN 0 and 1
ORDER BY row_num ASC;


-- checking the data quality
SELECT DISTINCT industry
FROM worlds_layoffs;

SELECT DISTINCT *
FROM worlds_layoffs
WHERE industry IS NULL or industry = ''
ORDER BY industry;

SELECT *
FROM worlds_layoffs
WHERE company LIKE 'Appsmith%';


SELECT DISTINCT country
FROM worlds_layoffs
ORDER BY country;

SELECT DISTINCT company
FROM worlds_layoffs
ORDER BY company;

-- deleting space  before company names
UPDATE worlds_layoffs
SET company = TRIM(' ' from company);


SELECT DISTINCT company
FROM worlds_layoffs
ORDER BY company;

-- checking the timeframe of data

SELECT MIN(date), MAX(date)
FROM worlds_layoffs;

-- checking NULL and empty records

SELECT *
FROM worlds_layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- deleting null and empty records 

DELETE from worlds_layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- checking the highest number of layoffs by country
SELECT country, SUM(total_laid_off)
FROM worlds_layoffs
GROUP BY country
ORDER BY 2 DESC;


-- checking the highest number of layoffs by industry
SELECT country, industry, SUM(total_laid_off) as max_layoffs
FROM worlds_layoffs
GROUP BY industry, country
ORDER BY max_layoffs DESC;

-- checking company with the highest number of layoffs
SELECT company, SUM(total_laid_off) as max_layoffs
FROM worlds_layoffs
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

SELECT company, country, total_laid_off
FROM worlds_layoffs;


SELECT *
FROM worlds_layoffs
WHERE industry = 'Aerospace';


ALTER TABLE world_layoffs DROP COLUMN row_num;

SELECT * from world_layoffs;

-- highest number of layoffs by YEAR

SELECT SUM(total_laid_off) as total_laid_off,
EXTRACT(year from date) as YEAR
from worlds_layoffs
GROUP BY 2
ORDER BY 1 DESC;


SELECT * from world_layoffs;

-- checking distinct list of stages
SELECT DISTINCT(stage), company, country
from worlds_layoffs
WHERE stage = '';

-- there are few empty strings, I'm standarising data and changed it to 'Unknown'
UPDATE worlds_layoffs
SET stage = 'Unknown'
WHERE stage = '';

SELECT * from world_layoffs;


-- listing 10 cities with the highest number of layoffs 

SELECT location, SUM(total_laid_off) as layoffs
FROM worlds_layoffs
GROUP BY location
ORDER BY layoffs DESC
LIMIT 5;

-- checking company/country with the highest number of layoffs
SELECT country, company, SUM(total_laid_off) as max_layoffs
FROM worlds_layoffs
WHERE country = 'United Kingdom'
GROUP BY country, company
ORDER BY country ASC, max_layoffs DESC;

-- company stage and made layoffs
 
SELECT stage, SUM(total_laid_off) as total_layoffs
FROM worlds_layoffs
GROUP BY stage
ORDER BY total_layoffs DESC;
