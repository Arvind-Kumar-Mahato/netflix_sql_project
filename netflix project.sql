---Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
show_id	VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),	
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description  VARCHAR(250)
);


SELECT * 
FROM netflix;



SELECT COUNT(*) AS total_content
FROM netflix;


SELECT DISTINCT type
FROM netflix;


--Business Problems and Solutions

--1. Count the Number of Movies vs TV Shows

SELECT
type,
COUNT(*) as total_content
FROM netflix
GROUP BY type;

 -- 2. Find the Most Common Rating for Movies and TV Shows

SELECT 
type,
rating
FROM
(
SELECT 
type,
rating,
COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM Netflix
Group BY 1,2
 
) as t1
where ranking =1



-- 3. List All Movies Released in a Specific Year (e.g., 2020)


  SELECT *
  FROM netflix
  WHERE type = 'Movie'
  AND
  release_year = '2020';



-- 4. Find the Top 5 Countries with the Most Content on Netflix


SELECT 
UNNEST(STRING_TO_ARRAY(country,',')) as new_counrty,
COUNT(show_id) as total_content
FROM netflix
Group BY 1
ORDER BY 2 DESC
LIMIT 5;



--5. Identify the Longest Movie


SELECT *
FROM netflix
WHERE type = 'Movie'
AND
duration = (SELECT MAX(duration) FROM netflix);



-- 6. Find Content Added in the Last 10 Years


SELECT *

FROM netflix

wHERE

TO_DATE(date_added, 'Month,DD,YYYY') >= CURRENT_DATE - INTERVAL '10 years';




-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM
(
SELECT *,
UNNEST(STRING_TO_ARRAY(director,',')) as director_name
FROM netflix
) AS t1
where director_name = 'Rajiv Chilaka';


SELECT *

FROM netflix

WHERE director  ILIKE '%Rajiv Chilaka%';




-- 8. List All TV Shows with More Than 5 Seasons

SELECT 
*
FROM netflix
WHERE 
type = 'TV Show'
AND
SPLIT_PART(duration,' ',1):: numeric > 5



-- 9. Count the Number of Content Items in Each Genre



SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1


-- 10.Find each year and the average numbers of content release in India on netflix.



SELECT 
 EXTRACT(YEAR FROM TO_DATE(date_added,'Month,DD,YYYY')) as year,
 COUNT(*) as yearly_content,
ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric*100,2)
 from netflix
 WHERE country = 'India'
 GROUP BY 1;




-- 11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';



-- 12. Find All Content Without a Director

SELECT *
FROM netflix
WHERE director IS NULL;


-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10;


-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India


SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT  10;



-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' in the description field.
Label conent containing these keywords as 'Bad' and all other contents as 'Good'. Count how many 
items fall into each category.


SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
