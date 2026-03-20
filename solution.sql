-- Netflix Project

CREATE TABLE netflix(

	show_id VARCHAR(6),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director VARCHAR(210),
	casts	VARCHAR(1000),
	country  VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)

);

SELECT * FROM netflix;

SELECT 
	COUNT(*) AS total_content
FROM netflix;

SELECT
	DISTINCT type
FROM netflix;

-- 15 Business Problems
-- 1. Count the number of Movies vs TV Shows.
SELECT
	type, COUNT(*) total_content
from netflix
GROUP BY type;
-- 2. Find the most common rating for movies and TV shows.

SELECT type, rating FROM 
	(SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY type, rating) as t1
	WHERE ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020).
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix.

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ','))  AS country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY UNNEST(STRING_TO_ARRAY(country, ','))
ORDER BY total_content DESC LIMIT 5;
-- 5. Identify the longest movie or TV show duration.

SELECT * FROM netflix
WHERE type = 'Movie' AND
		CAST(SPLIT_PART(duration, ' ', 1) AS INT) = (SELECT 
												MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INT))
												FROM netflix
												WHERE type = 'Movie');


-- 6. Find content added in the last 5 years.

SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= current_date - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'.
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons.
SELECT * FROM netflix
WHERE
	type = 'TV Show' AND
	CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5 ;
-- 9 Count the number of content items in each genre.
SELECT  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(show_id) FROM netflix
GROUP BY UNNEST(STRING_TO_ARRAY(listed_in, ',')) ;
-- 10. Find each year and the average number of content released by India on Netflix.
-- Return the top 5 years with the highest average content release.
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year, count(*),
	COUNT(*)::numeric/ (SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100 AS avg_content_per_year
	FROM netflix
WHERE country  ILIKE '%India%'
GROUP BY EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'));

-- 11. List all movies that are documentaries.
SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%';
-- 12. Find all content without a director.
SELECT * FROM netflix
WHERE director IS NULL;
-- 13. Find how many movies actor 'Salman Khan' appeared in the last 10 years.
SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%' AND
		release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
		COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY UNNEST(STRING_TO_ARRAY(casts, ',')) 
ORDER BY COUNT(*) DESC LIMIT 10;
-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other
-- content as 'Good'. Count how many items fall into each category.
SELECT 
    CASE 
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total
FROM netflix
GROUP BY category;