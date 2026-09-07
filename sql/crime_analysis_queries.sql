
-- Crime category breakdown by city
SELECT city, crime_category, COUNT(*) AS case_count
FROM crime_data
GROUP BY city, crime_category
ORDER BY city, case_count DESC;

-- Murder reason breakdown by city
SELECT city, murder_reason, COUNT(*) AS case_count
FROM crime_data
WHERE murder_reason != 'Not Applicable'
GROUP BY city, murder_reason
ORDER BY city, case_count DESC;

-- Total and average victims by city
SELECT city,
       SUM(total_victims) AS total_victims,
       ROUND(AVG(total_victims), 2) AS avg_victims_per_case
FROM crime_data
GROUP BY city
ORDER BY total_victims DESC;
