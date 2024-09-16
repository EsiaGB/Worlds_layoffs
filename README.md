## 📚 Worlds Layoffs
- [Data cleaning/exploring]
- [Business Task](#business-task)
- [Insights ](#Insights)


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
## Business task

###  The highest number of layoffs by country
```sql
SELECT country, SUM(total_laid_off)
FROM worlds_layoffs
GROUP BY country
ORDER BY 2 DESC;
```

### The highest number of layoffs by industry
```sql
SELECT country, industry, SUM(total_laid_off) as max_layoffs
FROM worlds_layoffs
GROUP BY industry, country
ORDER BY max_layoffs DESC;
```


### 10 top companies with the highest number of layoffs
```sql
SELECT company, SUM(total_laid_off) as max_layoffs
FROM worlds_layoffs
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;
```

SELECT company, country, total_laid_off
FROM worlds_layoffs;

### The highest number of layoffs by YEAR

```sql
SELECT SUM(total_laid_off) as total_laid_off,
EXTRACT(year from date) as YEAR
from worlds_layoffs
GROUP BY 2
ORDER BY 1 DESC;
```


### 5 top cities with the highest number of layoffs 
```sql
SELECT location, SUM(total_laid_off) as layoffs
FROM worlds_layoffs
GROUP BY location
ORDER BY layoffs DESC
LIMIT 5;
```

## Dashboard

![Dashboard 1](https://github.com/user-attachments/assets/eba877e1-dfa7-43fc-afb2-d30e6666c706)


