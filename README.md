## 📚 Worlds Layoffs
- [Business Task](#business-task)
- [Insights ](#Insights)



## Creating copy of the dataset

```sql -- 
CREATE TABLE world_layoffs
LIKE layoffs_1;

INSERT world_layoffs
SELECT * from layoffs_1;
``` -- 
