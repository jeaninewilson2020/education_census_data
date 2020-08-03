Basic Requirements

How many public high schools are in each zip code? In each state?

SELECT  COUNT(school_name) as schools,  zip_code
FROM public_hs
GROUP BY zip_code
ORDER BY 1 DESC; 


SELECT  COUNT(school_name) as schools,  state_code
FROM public_hs
GROUP BY 2
ORDER BY 1 DESC; 

The locale_code column in the high school data corresponds to 
various levels of urbanization as listed below. 
Use the CASE statement to display the corresponding locale_text and 
locale_size in your query result.

SELECT school_name, locale_code,

CASE WHEN locale_code <= 13 THEN 'City'
WHEN locale_code <= 23 THEN 'Suburb'
WHEN locale_code <= 33 THEN 'Town'
WHEN locale_code <= 43 THEN 'Rural'
END AS 'Urbanization',

CASE WHEN  locale_code <=23 THEN
CASE substr(locale_code, 2, 2)
WHEN '1' THEN 'Large'
WHEN '2' THEN 'Midsize'
WHEN '3' THEN 'Small'
END 

WHEN locale_code >=31 THEN 
CASE substr(locale_code, 2, 2)
WHEN '1' THEN 'Fringe'
WHEN '2' THEN 'Distant'
WHEN '3' THEN 'Remote'
ELSE 'No data'
END

END AS 'Size'
FROM public_hs;


What's the minimum, maximum and average median_household_income of the nation?
For each state?

For the nation:

SELECT MIN(median_household_income) AS Min, MAX(median_household_income) as Max, ROUND(AVG(median_household_income), 2) as Average
FROM  census_data
WHERE median_household_income != 'NULL';

For each state:

SELECT state_code, MIN(median_household_income) AS Min, MAX(median_household_income) as Max, ROUND(AVG(median_household_income), 2) as Average
FROM  census_data
WHERE median_household_income != 'NULL'
GROUP BY state_code;

Join the 2 tables together
Do characteristics of the zip code area, such as median household income, influence 
student's performance in high school?

SELECT ROUND(AVG(pct_proficient_math), 0) AS 'Math Results', ROUND (AVG(pct_proficient_reading), 0) AS 'Reading Results', 

CASE WHEN median_household_income <50000 THEN '<$50k'
WHEN median_household_income >= 50000 AND median_household_income <= 100000 THEN '$50-100k'
WHEN median_household_income > 100000 THEN '$100k+'
ELSE 'No data available'
END AS 'Income bracket'

FROM public_hs
JOIN census_data
ON  public_hs.zip_code = census_data.zip_code
WHERE median_household_income != 'NULL'
GROUP BY 3
ORDER BY 3 DESC; 

Intermediate Challenge:

On average, do students perform better on the math or reading exam?
Find the number of states where students do better on the math exam and vice versa.

WITH highest_results AS (SELECT ROUND(AVG(pct_proficient_math), 0) AS 'Math Results', ROUND (AVG(pct_proficient_reading), 0) AS 'Reading Results', state_code, 
CASE WHEN ROUND(AVG(pct_proficient_math), 0) > ROUND (AVG(pct_proficient_reading), 0) THEN 'Math'
WHEN ROUND (AVG(pct_proficient_reading), 0) > ROUND(AVG(pct_proficient_math), 0) THEN 'Reading'
ELSE 'No Exam Data'
END AS 'Highest_Subject'
FROM public_hs
GROUP BY 3)

SELECT COUNT(*) as 'Number of States', Highest_Subject
FROM highest_results
GROUP BY Highest_Subject;

Advanced Challenge:

What's the average proficiency on state assessment exams for each zip code, and how do they compare to other zip codes in the same state? 
Figure out state average and then how zip codes compare to that average 

WITH state_results AS (SELECT public_hs.state_code as 'State', ROUND(AVG(pct_proficient_math), 0) AS 'State_Math_Avg', ROUND (AVG(pct_proficient_reading), 0) AS 'State_Reading_Avg', MAX(pct_proficient_math) AS 'Max Math Score', MIN(pct_proficient_math) AS 'Min Math Score',
MAX(pct_proficient_reading) AS 'Max Reading Score', MIN(pct_proficient_reading) AS 'Min Reading Score'
FROM public_hs
GROUP BY 1)


SELECT state_results.state, public_hs.zip_code, state_results.State_Math_Avg, ROUND(AVG(pct_proficient_math), 0) AS 'Zip_Math_Avg', state_results.State_Reading_Avg, 
ROUND(AVG(pct_proficient_reading), 0) AS 'Zip_Reading_Avg'
FROM public_hs
JOIN state_results
ON public_hs.state_code = state_results.state
GROUP BY 2; 