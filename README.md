App Store Data Analysis – SQL Project
Project Overview
This project focuses on analyzing a dataset of apps available in the App Store, sourced from Kaggle. The goal is to extract valuable insights for aspiring app developers to inform their decisions regarding app development, pricing strategies, and maximizing user ratings.

Dataset
The dataset, Applestore.csv, was too large to be imported into an SQLite database all at once. As a solution, it was split into five parts, and the parts were combined using SQL after import.

Stakeholders
The primary stakeholders for this analysis are aspiring app developers who need data-driven insights to decide:

What app categories are most popular
Optimal pricing strategies for paid apps
How to maximize user ratings
Analysis Process
Step 1: Data Import & Table Creation
Due to SQLite’s 4MB file size limitation, the dataset was divided into 5 parts. After importing each part, the datasets were merged into a single table using the following SQL command:
SQL
-- Step 1: Create Combined Table from Multiple Parts

CREATE TABLE appleStore_description_combined AS
SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4;

-- Step 2: Exploratory Data Analysis (EDA)

-- Question 1: How many unique apps are there in the dataset?
SELECT COUNT(DISTINCT id) AS UniqueAppleIDs FROM AppleStore;

-- Question 2: Are there any missing values in key fields?
SELECT COUNT(*) AS MissingValues 
FROM AppleStore 
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

-- Question 3: How many apps belong to each genre?
SELECT prime_genre, COUNT(*) AS NumApps 
FROM AppleStore 
GROUP BY prime_genre 
ORDER BY NumApps DESC;

-- Question 4: What is the distribution of user ratings in the dataset?
SELECT MIN(user_rating) AS MinRating, MAX(user_rating) AS MaxRating, AVG(user_rating) AS AvgRating 
FROM AppleStore;

-- Question 5: What is the distribution of app prices in the dataset?
SELECT (price / 2) * 2 AS PriceBinStart, ((price / 2) * 2) + 2 AS PriceBinEnd, COUNT(*) AS NumApps 
FROM AppleStore 
GROUP BY PriceBinStart 
ORDER BY PriceBinStart;

-- Step 3: Data Analysis & Insights

-- Question 6: Do paid apps have higher ratings than free apps?
SELECT CASE WHEN price > 0 THEN 'Paid' ELSE 'Free' END AS App_Type, AVG(user_rating) AS Avg_Rating 
FROM AppleStore 
GROUP BY App_Type;

-- Question 7: Do apps that support more languages have higher ratings?
SELECT CASE 
    WHEN lang_num < 10 THEN ' < 10 languages' 
    WHEN lang_num BETWEEN 10 AND 30 THEN ' 10 - 30 languages' 
    ELSE ' > 30 languages' 
END AS language_bucket, AVG(user_rating) AS AVG_Rating 
FROM AppleStore 
GROUP BY language_bucket 
ORDER BY AVG_Rating DESC;

-- Question 8: Which genres have the lowest user ratings?
SELECT prime_genre, AVG(user_rating) AS AVG_Rating 
FROM AppleStore 
GROUP BY prime_genre 
ORDER BY AVG_Rating ASC 
LIMIT 10;

-- Question 9: Is there a correlation between the length of an app’s description and its user rating?
SELECT CASE 
    WHEN LENGTH(b.app_desc) < 500 THEN 'Short' 
    WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium' 
    ELSE 'Long' 
END AS description_length_bucket, AVG(user_rating) AS AVG_Rating 
FROM AppleStore AS A 
JOIN appleStore_description_combined AS B ON A.id = B.id 
GROUP BY description_length_bucket 
ORDER BY AVG_Rating DESC;

-- Question 10: What are the top-rated apps for each genre?
SELECT prime_genre, track_name, user_rating 
FROM ( 
    SELECT prime_genre, track_name, user_rating, 
           RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank 
    FROM AppleStore 
) AS a 
WHERE a.rank = 1;

Key Insights & Recommendations
Paid apps generally receive higher ratings than free apps.
Apps that support 10 to 30 languages perform better in terms of user ratings.
Finance and books apps tend to receive lower ratings.
Longer app descriptions (above 1000 characters) are correlated with better ratings.
Games and entertainment apps dominate the App Store but face high competition.
New apps should aim for an average rating of at least 3.5 to compete effectively.
Conclusion
This analysis provides aspiring app developers with key insights into the app market, focusing on genre selection, pricing, and strategies to maximize user ratings.
