# App Store Data Analysis – SQL Project



## Overview
The App Store is a competitive marketplace for app developers, with millions of apps across various categories. This project focuses on analyzing a dataset of apps available in the App Store, sourced from Kaggle, to extract valuable insights that can guide aspiring app developers. The goal is to provide data-driven insights that inform decisions regarding app development, pricing strategies, and maximizing user ratings.



## Objectives

- Identify popular app categories: Determine which genres of apps are the most popular based on the number of apps in each genre.
- Examine pricing strategies: Analyze the price distribution to understand optimal pricing for paid apps.
- Assess user ratings: Investigate which factors influence user ratings, such as app type (paid or free), number of supported languages, and app description length.
- Compare paid vs. free apps: Determine whether paid apps generally have higher user ratings than free apps.
- Provide actionable insights: Offer recommendations for aspiring app developers based on data-driven insights to improve their app development strategies.
- Highlight top-rated apps per genre: Identify which apps perform the best within each genre to serve as benchmarks for developers.

## Techniques Used.
The analysis employed the following techniques:
1. Data Cleaning and Merging:
   - Divided the large dataset into smaller parts due to SQLite's file size limitations.
   - Merged the dataset into a single table using the UNION ALL command for comprehensive analysis.
2. Exploratory Data Analysis (EDA)
   - Used SQL queries to explore the dataset, calculate key metrics (e.g., unique apps, genre distribution), and detect missing values.
   - Examined the distribution of user ratings and app prices to better understand the spread and range of the data.
3. Grouping and Aggregation:
   - Applied SQL GROUP BY and COUNT functions to categorize apps by genre and app type (free vs. paid) and calculate average ratings, pricing bins, and language support         ranges.
4. Ranking and Correlation:
   - Utilized RANK() and conditional statements in SQL to identify top-rated apps for each genre and to assess the relationship between different factors (e.g.,                 description length, number of languages) and user ratings.
5. Data Interpretation for Decision-Making:
   - Analyzed the results to derive insights on the most popular genres, optimal pricing strategies, and factors that contribute to higher user ratings.
   - Generated actionable recommendations for app developers to enhance app performance in terms of both popularity and user satisfaction.
## Dataset

The dataset, Applestore.csv, contains key attributes such as app name, genre, price, and user ratings. Due to SQLite’s 4MB file size limitation, the dataset was divided into five parts. These parts were combined into a single table using SQL after import to ensure all data could be analyzed collectively.

Total records: X apps
Key columns: id, track_name, price, user_rating, prime_genre, lang_num, app_desc

## Stakeholders

The primary stakeholders for this analysis are aspiring app developers who need data-driven insights to decide:
-  What app categories are most popular
-  Optimal pricing strategies for paid apps
-  How to maximize user ratings



## Analysis Process
# Step 1:Data Import & Table Creation.
Due to the file size limitation in SQLite, the dataset was divided and later merged into a single table. Below is the SQL command used to combine the dataset:


- Tool used for analysis **SQLite**.
```
CREATE TABLE appleStore_description_combined AS
SELECT *
FROM appleStore_description1
UNION ALL
SELECT *
FROM appleStore_description2
UNION ALL
SELECT *
FROM appleStore_description3
UNION ALL
SELECT *
FROM appleStore_description4;


```
## CSV file uploaded to database.
- [Download CSV file - Github ](https://github.com/Bhargav-tej/App-Store_Data_Analysis)


## Step 2: Exploratory Data Analysis (EDA)
A series of exploratory queries were run to gain initial insights from the dataset.

-- 1. How many unique apps are there in the dataset?

```
SELECT
        COUNT(DISTINCT id) AS UniqueAppleIDs
FROM AppleStore;

```
-- 2. Are there any missing values in key fields?
```
SELECT COUNT(*) AS MissingValues 
FROM AppleStore 
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;
```
-- 3. How many apps belong to each genre?
```
SELECT  prime_genre,
        COUNT(*) AS NumApps 
FROM AppleStore 
GROUP BY prime_genre 
ORDER BY NumApps DESC;
```
-- 4. What is the distribution of user ratings in the dataset?
```
SELECT
        MIN(user_rating) AS MinRating,
        MAX(user_rating) AS MaxRating,
        AVG(user_rating) AS AvgRating 
FROM AppleStore;
```
-- 5. What is the distribution of app prices in the dataset?
```
SELECT  (price / 2) * 2 AS PriceBinStart,
        ((price / 2) * 2) + 2 AS PriceBinEnd,
        COUNT(*) AS NumApps 
FROM AppleStore 
GROUP BY PriceBinStart 
ORDER BY PriceBinStart;
```
## Step 3: Data Analysis & Insights

-- 6. Do paid apps have higher ratings than free apps?
```
SELECT
        CASE
            WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
        END AS App_Type,
        AVG(user_rating) AS Avg_Rating 
FROM AppleStore 
GROUP BY App_Type;

```
-- 7. Do apps that support more languages have higher ratings?

```
SELECT
        CASE 
            WHEN lang_num < 10 THEN ' < 10 languages' 
            WHEN lang_num BETWEEN 10 AND 30 THEN ' 10 - 30 languages' 
            ELSE ' > 30 languages' 
        END AS language_bucket,
        AVG(user_rating) AS AVG_Rating 
FROM AppleStore 
GROUP BY language_bucket 
ORDER BY AVG_Rating DESC;

```

-- 8. Which genres have the lowest user ratings?
```
SELECT  prime_genre,
        AVG(user_rating) AS AVG_Rating 
FROM AppleStore 
GROUP BY prime_genre 
ORDER BY AVG_Rating ASC 
LIMIT 10;
```

-- 9. Is there a correlation between the length of an app’s description and its user rating?
```
SELECT
        CASE 
            WHEN LENGTH(b.app_desc) < 500 THEN 'Short' 
            WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium' 
            ELSE 'Long' 
        END AS description_length_bucket,
        AVG(user_rating) AS AVG_Rating 
FROM AppleStore AS A 
JOIN appleStore_description_combined AS B ON A.id = B.id 
GROUP BY description_length_bucket 
ORDER BY AVG_Rating DESC;
	   
```
-- 10. What are the top-rated apps for each genre? 
```
SELECT
    prime_genre,
    track_name,
    user_rating
FROM (
    SELECT
        prime_genre,
        track_name,
        user_rating,
        RANK() OVER (
            PARTITION BY prime_genre 
            ORDER BY user_rating DESC, rating_count_tot DESC
        ) AS rank
    FROM
        AppleStore
) AS a
WHERE
    a.rank = 1;

```
## Key Insights & Recommendations
  - Paid apps generally receive higher ratings than free apps.
  - Apps that support 10 to 30 languages perform better in terms of user ratings.
  - Finance and books apps tend to receive lower ratings.
  - Longer app descriptions (above 1000 characters) are correlated with better ratings.
  - Games and entertainment apps dominate the App Store but face high competition.
  - New apps should aim for an average rating of at least 3.5 to compete effectively.
## Conclusion
This analysis provides aspiring app developers with key insights into the app market, focusing on genre selection, pricing, and strategies to maximize user ratings. By understanding the competitive landscape, developers can make informed decisions to improve their app’s chances of success.

## Future Work & Limitations
  - A deeper analysis could explore app performance over time and track how updates affect user ratings.
  - This analysis is based on static data and does not account for regional trends or app performance variations over time, which would require more granular datasets.

