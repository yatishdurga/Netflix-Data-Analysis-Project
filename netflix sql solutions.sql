-- Neflix project 
CREATE TABLE  netflix
(
	show_id VARCHAR(6),
	type	VARCHAR(10),
	title  VARCHAR(150),
	director VARCHAR(208),
	casts	VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description_m VARCHAR(250)
)

select * from netflix;



-- 15 Business problems 
-- 1.count the number of movies vs TV shows
select type,
count(*) as total_content
from netflix
group by type; 

-- 2.Find the most common rating for movies and TV shows 
SELECT TYPE,RATING FROM
	(
	select type,
		rating,
		count(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS RANKING
	from netflix
	group by 1,2
	) AS t1
WHERE RANKING=1
-- order by 1,3 desc;

--3.List All movies released in a specific year ex.2020
SELECT * FROM netflix 
WHERE type='Movie' AND release_year=2020;


--4.Find the top 5 countries with the most content on Netflix 
select 
unnest(string_to_array(country,',')) as new_country,
		count(show_id) as total_count
		from netflix  group by 1
		order by 2 desc
		limit 5

-- 5. Identify the longest movie
select * from netflix
where 
	type='Movie'
	and 
	duration=(select max(duration) from netflix)

-- 6.Find the content added in the last 5 years
select * from netflix
	where
	TO_DATE(date_added,'Month DD,YYYY')>=current_date-INTERVAL '5 YEARS';

--7.Find all the movies /Tv shows by director 'Rajiv Chilaka'
-- ILIKE will be useful for the retriving the case sensitive 
select * from netflix where director ILIKE '%Rajiv Chilaka%';


--8.List all the tv shows with more than 5 seasons
SELECT *
	FROM netflix 
	WHERE
		TYPE= 'TV Show'
		AND
		SPLIT_PART(duration,' ',1)::numeric > 5

-- 9.Count the number of content items in each genre

SELECT 
    genre, 
    COUNT(show_id) AS total_content
FROM 
    netflix, 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
GROUP BY genre;


-- 10. Find each year and the average numbers of content release by India on ndtflix.
--return top 5 year with highest avg content release !
SELECT 
	EXTRACT(YEAR FROM TO_DATE (date_added, 'Month DD, YYYY')) as year, 
	COUNT (*) as yearly_content,
	ROUND( 
	COUNT (*)::numeric/ (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
	,2) as avg_content_per_year
FROM netflix 
WHERE country = 'India'
GROUP BY 1 


--11.List all the movies that are documentaries
select * from netflix
where
	listed_in ilike '%documentaries%'


--12. Find all content without a director
select * from netflix 
where 
	director is null;

--13.Find how many movies actor salman khan appeared in last 10 years

select * from netflix
where 	
	casts ilike '%Salman khan%'
	and 
	release_year>extract(year from current_date)-10

--14.Find the top 10 actors who appeared in the highest number of movies in india.

select  
	unnest(string_to_array(casts,',')) as actors,
	count(*) as total_content
	from netflix where country ilike '%india'
	group by 1
	order by 2 desc
	limit 10
	
--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field.Label content containing these keywords as 'Bad’ and all other 
--content as 'Good'.Count how many items fall into each category.

WITH new_table
AS(
select 
*, 
	case 
	when 
	description_m ilike '%kills%' or 
	description_m ilike '%voilence%' then 'Bad_Content' else 'Good_Content'
	end category 
from netflix
)
select category,
	count(*) as total_content
	from new_table 
	group by 1






