-- =======================================================
-- Project: Netflix Content Strategy & Audience Analysis
-- Database: Google BigQuery / SQL
-- =======================================================

-- Code 1: Content Growth Trend (Since 2010): Movies vs TV Shows
SELECT 
    release_year,
    COUNTIF(type = 'Movie') AS movies_count,
    COUNTIF(type = 'TV Show') AS tv_show_count 
FROM `strange-theme-429815-j5.netflix_data.second_project`
WHERE release_year >= 2010
GROUP BY release_year
ORDER BY release_year ASC;

-- Code 2: Top 5 Directors with the Most Content
SELECT 
    director,
    COUNT(*) AS total_content 
FROM `strange-theme-429815-j5.netflix_data.second_project`
WHERE director IS NOT NULL AND director != ''
GROUP BY director
ORDER BY total_content DESC
LIMIT 5;

-- Code 3: Production Model: Single Country vs Co-Production
SELECT 
    CASE 
        WHEN country LIKE '%,%' THEN 'Co-Production'
        ELSE 'Single Country' 
    END AS production_type,
    COUNT(*) AS total_content
FROM `strange-theme-429815-j5.netflix_data.second_project`
WHERE country IS NOT NULL AND country != ''
GROUP BY production_type
ORDER BY total_content DESC;

-- Code 4: Audience Segmentation: Content Share by Rating (%)
SELECT 
    rating,
    COUNT(*) AS total_content,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM `strange-theme-429815-j5.netflix_data.second_project` WHERE rating IS NOT NULL AND rating != ''), 
        2
    ) AS percentage
FROM `strange-theme-429815-j5.netflix_data.second_project`
WHERE rating IS NOT NULL AND rating != ''
GROUP BY rating
ORDER BY total_content DESC;

-- Code 5: Film Duration Metrics (Average, Min, Max Runtime)
SELECT
    COUNT(*) AS total_movies,
    ROUND(AVG(SAFE_CAST(REPLACE(duration, ' min', '') AS INT64)), 1) AS avg_duration_min,
    MIN(SAFE_CAST(REPLACE(duration, ' min', '') AS INT64)) AS min_duration_min,
    MAX(SAFE_CAST(REPLACE(duration, ' min', '') AS INT64)) AS max_duration_min
FROM `strange-theme-429815-j5.netflix_data.second_project`
WHERE type = 'Movie'
  AND duration IS NOT NULL
  AND duration LIKE '%min%';
