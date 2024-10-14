CREATE table appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4 

**Explotatory data analysis**
-- check the number of unique apps in both tableApplestore 
SELECT count (DISTINCT id) AS UniqueAppleIDs
FROM AppleStore


SELECT count (DISTINCT id) AS UniqueAppleIDs
FROM appleStore_description_combined

-- check for any missing values in key fields

SELECT COUNT (*) AS MissingValues
FROM AppleStore
WHERE track_name is NULL or user_rating is NULL or prime_genre is NULL

SELECT COUNT (*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is NULL

-- Find out the number of apps per gener 

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP by prime_genre
ORDER by NumApps DESC

-- Get an overview of the apps ratings

SELECT min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

-- Get the distribution of app price

SELECT
	(price/2) *2 as PriceBinStart,
    ((price/2) *2) +2 As prceBinEnd,
    COUNT(*) as Numapps
FROM AppleStore

GROUP by PriceBinStart
order by PriceBinStart


** DATA ANALYSIS**
--Determine whether paid apps have higher ratings than free apps 

SELECT CASE
			when price > 0 Then 'Paid'
            ELSE 'Free'
		END as App_Type,
        Avg(user_rating) as Avg_Rating 
from AppleStore
GROUP by App_Type

-- check if apps with more supported languages have higher rating 

SELECT CASE
			when lang_num < 10 THEN ' < 10 languages'
            when lang_num BETWEEN 10 and 30  THEN ' 10 - 30 languages'
            ELSE ' > 30 languages'
       end as language_bucket,
       Avg(user_rating) as AVG_Rating
FROM AppleStore
GROUP by language_bucket
ORDER by AVG_Rating DESC

-- check geners with low rating 

SELECT prime_genre,
	   Avg(user_rating) as AVG_Rating
FROM AppleStore
GROUP by prime_genre
ORDER By AVG_Rating ASC
LIMIT 10 

-- check if there is correlation between the lenght of the app description and the user rating 

SELECT CASE	
			when length(b.app_desc) <500 then 'short'
            when length(b.app_desc) BETWEEN 500 and 1000  then 'Medium'
            ELSE 'Long'
			END as description_length_bucket,
             Avg(user_rating) as AVG_Rating
from 
	 AppleStore as A 
JOIN 
	appleStore_description_combined As B 
on 
	A.id = B.id 
GROUP By description_length_bucket 
order by  AVG_Rating DESC

-- check the top-rated apps for each genre 

SELECT 
      prime_genre,
      track_name,
      user_rating
FROM (
	  SELECT  
  	  prime_genre,
      track_name,
      user_rating,
   	  RANK() OVER (PARTITION BY prime_genre ORDER by user_rating DESC, rating_count_tot DESC ) AS rank 
      FROM
      AppleStore
	 ) as a
WHERE 
a.rank = 1 
 










