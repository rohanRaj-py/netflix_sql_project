# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/rohanRaj-py/netflix_sql_project/blob/main/Netflix%20Logo.png)

## Overview

This project involves analyzing Netflix movies and TV shows dataset using SQL. The goal is to solve real-world business problems and extract meaningful insights from the data.

---

## Objectives

* Analyze distribution of Movies vs TV Shows
* Identify most common ratings
* Explore content by year, country, and duration
* Perform data transformation using SQL functions
* Categorize content using conditional logic

---

## Dataset

Source: Kaggle Netflix Dataset

---

## Schema

```sql
CREATE TABLE netflix(
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(210),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);
```

---

# Business Problems & Solutions

## 1. Count Movies vs TV Shows

```sql
SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

---

## 2. Most Common Rating for Movies and TV Shows

```sql
SELECT type, rating
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS total,
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) t
WHERE ranking = 1;
```

---

## 3. Movies Released in 2020

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
AND release_year = 2020;
```

---

## 4. Top 5 Countries with Most Content

```sql
SELECT country, COUNT(*) AS total_content
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country
    FROM netflix
) t
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;
```

---

## 5. Longest Movie

```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) = (
    SELECT MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INT))
    FROM netflix
    WHERE type = 'Movie'
);
```

---

## 6. Content Added in Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

---

## 7. Content by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

---

## 8. TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;
```

---

## 9. Content Count by Genre

```sql
SELECT genre, COUNT(*) AS total_content
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
    FROM netflix
) t
GROUP BY genre;
```

---

## 10. Top 5 Years with Highest Content Release in India

```sql
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY year
ORDER BY total_content DESC
LIMIT 5;
```

---

## 11. Documentary Movies

```sql
SELECT *
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';
```

---

## 12. Content Without Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL OR director = '';
```

---

## 13. Salman Khan Movies in Last 10 Years

```sql
SELECT COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
AND casts ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

---

## 14. Top 10 Actors in Indian Movies

```sql
SELECT actor, COUNT(*) AS total_content
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor
    FROM netflix
    WHERE country ILIKE '%India%'
) t
GROUP BY actor
ORDER BY total_content DESC
LIMIT 10;
```

---

## 15. Categorize Content (Good vs Bad)

```sql
SELECT 
    CASE 
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total
FROM netflix
GROUP BY category;
```

---

# Key Learnings

* Used **Window Functions (RANK)** for ranking problems
* Applied **STRING_TO_ARRAY & UNNEST** for handling multi-value columns
* Converted string data to numeric using **SPLIT_PART + CAST**
* Used **CASE** for conditional categorization
* Worked with **date functions** for time-based analysis

---

# Conclusion

This project demonstrates how SQL can be used to solve real-world business problems by transforming raw data into meaningful insights. It covers data cleaning, aggregation, filtering, and advanced SQL techniques, making it a strong foundation for data analysis and backend roles.

---

