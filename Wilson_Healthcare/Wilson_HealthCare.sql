/*
----- <Scenario> -----
You're a data analyst at Wilson Healthcare Ltd., tasked with creating a compelling flu shots dashboard for 2022.

----- <Objective> -----
Craft a concise and visually striking flu shots dashboard for 2022, detailing vaccination trends among active patients 
at Wilson Healthcare Ltd.

----- < Problem Statement > 
You need to compile and analyze flu shot data for 2022, filtering out inactive patients. 
Present the percentage of flu shots by age, race, and county on a map, alongside an overall summary. 
Additionally, display the running total of flu shots administered, the total count, and provide a clear list of patients 
indicating their vaccination status. This concise dashboard will offer actionable insights for healthcare decision-makers, 
aiding in strategic planning and resource allocation.

----- < Break down > -----
1.) Total % of patients getting flu shots stratified
	a. Age
	b. Race
	c. County (on Map)
	d. Overall
	
2.) Running total of flu shots over the course of 2022
3.) Total number of flu shots given in 2022
4.) A list of patients that show whether or not they received the flu shots

Requirements:
-- patients must have been "Active at our hospital"
-- patients receving the shot should be 6 months and older

*/


-- _____________________________________________ 	SOLUTION	________________________________________________________________
SELECT * FROM encounters;
SELECT * FROM patients;

-- Query for 'active_patients' and 'flu_shot_2022'
WITH active_patients AS (

	SELECT
		DISTINCT patient
	FROM encounters e
	INNER JOIN patients pat ON e.patient = pat.id
	WHERE pat.deathdate IS NULL
	AND EXTRACT(MONTH FROM age('2022-12-31', pat.birthdate)) >= 6
	
),
flu_shot_2022 AS ( 
	SELECT 
		patient,
		min(date) AS earliest_flu_shot
	FROM immunizations
	WHERE code = '5302' 			-- Seasonal flu vaccine code
		AND date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
	GROUP BY 1
)
SELECT 
	pat.id,
	pat.birthdate,
	extract(YEAR FROM age('12-31-2022', birthdate)) AS age,
	pat.race,
	pat.county, 
	pat.first,
	pat.last,
	flu.patient,
	flu.earliest_flu_shot,
	CASE											-- This CASE will help to caluclate percentage and totals
		WHEN flu.patient IS NOT NULL THEN 1
		ELSE 0 
		END AS flu_shot_2022
FROM patients pat 
LEFT JOIN flu_shot_2022 flu ON flu.patient = pat.id
WHERE 
	1=1 
	AND pat.id IN (SELECT patient FROM active_patients);










