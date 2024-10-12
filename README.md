# 🎬 Netflix Data Analysis Using SQL

## 📑 Project Overview
This project dives deep into Netflix's dataset to uncover meaningful insights about its content, including trends in movies, TV shows, regional content distribution, and genre popularity. The goal is to leverage SQL to perform detailed analysis that could guide business decisions for content strategies, regional investments, and audience engagement.


Dataset Source: [Netflix Dataset on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## 🧠 What We Learned
During this analysis, several key concepts and techniques were explored:
- **SQL Window Functions**: Used for ranking and finding the most common ratings.
- **String Manipulation**: To split and analyze content attributes like countries and cast members.
- **Text Analysis**: Applied to categorize content based on descriptions using keywords such as “kill” and “violence.”
- **Date and Time Functions**: To filter content added in recent years and analyze content trends by release year.
- **Aggregation & Grouping**: Count content by various categories like genre, type, and country.

## ⚙️ Technologies Used
### SQL ,PostgreSQL

## 📈 Potential Business Impact
The insights gained from this analysis can help Netflix or similar streaming platforms:
- Optimize content production based on regional trends.
- Understand genre popularity and viewer preferences.
- Improve decision-making related to content acquisition and marketing strategies.

- -- Netflix Data Analysis Project using SQL

```sql
CREATE TABLE netflix (
    show_id VARCHAR(6),
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
    description_m VARCHAR(250)
);
```

### Query to verify the data
SELECT * FROM netflix;

### 1. Count the number of movies vs TV shows
```sql
SELECT 
    type, 
    COUNT(*) AS total_content 
FROM netflix 
GROUP BY type;
```

### 2. Find the most common rating for movies and TV shows
```sql
SELECT type, rating 
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS count, 
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking 
    FROM netflix 
    GROUP BY 1, 2
) AS t1 
WHERE ranking = 1;
```

### 3. List all movies released in a specific year (e.g., 2020)
```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' AND release_year = 2020;
```

### 4. Find the top 5 countries with the most content on Netflix
```sql
SELECT 
    UNNEST(string_to_array(country, ',')) AS new_country, 
    COUNT(show_id) AS total_count 
FROM netflix  
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 5;
```

### 5. Identify the longest movie by duration
```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM netflix);
```

### 6. Find the content added in the last 5 years
```sql
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';
```

### 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
```sql
SELECT * 
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%';
```

### 8. List all the TV shows with more than 5 seasons
```sql
SELECT * 
FROM netflix 
WHERE type = 'TV Show' 
AND SPLIT_PART(duration, ' ', 1)::numeric > 5;
```

### 9. Count the number of content items in each genre
```sql
SELECT 
    genre, 
    COUNT(show_id) AS total_content 
FROM netflix, 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre 
GROUP BY genre;
```

### 10. Find each year and the average number of content released by India on Netflix (Top 5 years)
```sql
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year, 
    COUNT(*) AS yearly_content, 
    ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) AS avg_content_per_year 
FROM netflix 
WHERE country = 'India' 
GROUP BY 1;
```

### 11. List all the movies that are documentaries
```sql
SELECT * 
FROM netflix 
WHERE listed_in ILIKE '%documentaries%';
```

### 12. Find all content without a director
```sql
SELECT * 
FROM netflix 
WHERE director IS NULL;
```

### 13. Find how many movies actor Salman Khan appeared in the last 10 years
```sql
SELECT * 
FROM netflix 
WHERE casts ILIKE '%Salman Khan%' 
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### 14. Find the top 10 actors who appeared in the highest number of movies in India
```sql
SELECT 
    UNNEST(string_to_array(casts, ',')) AS actors, 
    COUNT(*) AS total_content 
FROM netflix 
WHERE country ILIKE '%India%' 
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 10;
```

### 15. Categorize content based on the presence of the keywords 'kill' and 'violence' in the description field 
### Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
```sql
WITH new_table AS (
    SELECT *, 
        CASE 
            WHEN description_m ILIKE '%kill%' OR description_m ILIKE '%violence%' THEN 'Bad_Content' 
            ELSE 'Good_Content' 
        END AS category 
    FROM netflix
)
SELECT 
    category, 
    COUNT(*) AS total_content 
FROM new_table 
GROUP BY 1;
```




## 🤝 Contributing
Feel free to open an issue or submit a pull request for any improvements.

---
