# 📚 Worlds Layoffs

 1. [Data cleaning/exploring](#data-cleaning/exploring)
 2. [Dashboard](#dashboard)


## Data cleaning/exploring 
### Creating copy of the dataset

```sql
CREATE TABLE world_layoffs
LIKE layoffs_1;

INSERT world_layoffs
SELECT * from layoffs_1;
```

### Checking duplicated records

```sql
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
```
### Checking if duplicates are removed
```sql
DELETE FROM worlds_layoffs
WHERE row_num >1;
```

### Checking data quality
```sql
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

UPDATE worlds_layoffs
SET company = TRIM(' ' from company);

SELECT *
FROM worlds_layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT(stage), company, country
from worlds_layoffs
WHERE stage = '';

UPDATE worlds_layoffs
SET stage = 'Unknown'
WHERE stage = '';
```
### Deleting null and empty records

```sql
DELETE from worlds_layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```
## Questions

###  The highest number of layoffs by country
```sql
SELECT country, SUM(total_laid_off)
FROM worlds_layoffs
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;
```
<img width="243" alt="Screenshot 2024-09-16 at 17 00 12" src="https://github.com/user-attachments/assets/9d14caa4-13d8-4a8d-85dd-6451aa1cfef3">

### Total layoffs by industry 
```sql
SELECT country, industry, SUM(total_laid_off) as max_layoffs
FROM worlds_layoffs
GROUP BY industry, country
ORDER BY max_layoffs DESC;
```
<img width="192" alt="Screenshot 2024-09-16 at 17 11 28" src="https://github.com/user-attachments/assets/b986a455-7eba-408c-8813-79cb216625c5">


### 10 top companies with the highest number of layoffs
```sql
SELECT company, SUM(total_laid_off) as max_layoffs
FROM worlds_layoffs
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;
```
<img width="178" alt="Screenshot 2024-09-16 at 16 57 55" src="https://github.com/user-attachments/assets/8935adf6-8fab-4fa7-a840-841e10bad99a">

SELECT company, country, total_laid_off
FROM worlds_layoffs;

### The highest number of layoffs by month

```sql
SELECT SUM(total_laid_off) as total_laid_off,
EXTRACT(year from date) as YEAR,
EXTRACT(MONTH FROM date) as MONTH
from worlds_layoffs
GROUP BY 2, 3
ORDER BY 1 DESC;
```

## Dashboard

![Dashboard 1](https://github.com/user-attachments/assets/eba877e1-dfa7-43fc-afb2-d30e6666c706)


