DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
select * from netflix;

select 
count(*) as total_content
from netflix;

select 
distinct type from netflix;

select * from netflix;

-- 15 business problems
--1. count the number of movies vs TV shows
select type ,
count(*) as total_content 
from netflix
group by type


--2 find the most common rating for movies and tv shows
select type,
rating from 
(
select 
type,
rating,
count(*),
rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
) as T1
where ranking=1


--3 list all movies released in a specific year(e.g.,2020)
select * from netflix
where type='Movie' and release_year=2020;


--4 find the top 5 countries with the most content on netflix
 select 
 unnest(string_to_array(country,','))as new_country,
 count(show_id)as total_content
from netflix
group by 1
order by 2 desc
limit 5

--5 Identify the Longest Movie
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;


--6 Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';



--7 find all the movies/TV shows by director 'rajiv chilaka'
select * from netflix
where director like '%Rajiv Chilaka%';


--8 list all TV shows with more than 5 seasons
select *
from netflix 
where
type='TV Show'
and
SPLIT_PART(duration,' ',1)::numeric>5


--9 count the number of content items in each genre
select 
unnest(string_to_array(listed_in,',')) as genre,
count(show_id) as total_content
from netflix
group by 1;


--10 fine each year and average numbers of content realease by India on netflix,
--   return top 5 year with highest avg content release
total content 333/972
	select 
	extract(year from to_date(date_added,'month DD,yyyy'))as year,
	count(*) as yearly_content,
	round(
	count(*)::numeric/(select count(*) from netflix where country= 'India')::numeric * 100 
	,2)as avg_content_per_year
	from netflix
	where country='India'
	group by 1


--11 list all movies that are documentries
select * from netflix
where 
listed_in like '%Documentaries%';


--12 find all content without a director
select * from netflix
where director is null;


--13 find how many movies actor 'salman khan'appeared in last 10 years;
select * from netflix
where 
casts like '%Salman Khan%'
and
release_year > EXTRACT(year from current_date) - 10;


--14 find the top 10 actors who have appeared in the highest number of movies produced in 
select
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix 
where country like '%India%'
group by 1
order by 2 desc
limit 10


--15 Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
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