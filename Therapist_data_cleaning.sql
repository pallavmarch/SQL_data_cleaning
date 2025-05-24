CREATE TABLE therapist_profiles (
    profile_url TEXT,
    name_header TEXT,
    location TEXT,
    sessions TEXT,
    insurance TEXT,
    top_specialties TEXT,
    expertise TEXT,
    types_of_therapy TEXT,
    qualification_section TEXT,
    other_details TEXT
);


SELECT * from therapist_profiles limit 25

select count(*) from therapist_profiles  --Total rows 55139


SELECT profile_url, ROW_NUMBER() OVER(PARTITION BY profile_url) AS row_num
from therapist_profiles
order by row_num desc
--There are some duplicates

WITH duplicates as
(SELECT profile_url, ROW_NUMBER() OVER(PARTITION BY profile_url) AS row_num
from therapist_profiles
order by row_num desc)
select * from duplicates
where row_num > 1

--Just to be sure of duplicates
SELECT *
FROM therapist_profiles
WHERE profile_url = 'https://www.psychologytoday.com/us/therapists/joel-salinas-orlando-fl/1306086';
-- 3 similar rows

WITH duplicates as
(SELECT profile_url, ROW_NUMBER() OVER(PARTITION BY profile_url) AS row_num
from therapist_profiles
order by row_num desc)
DELETE FROM therapist_profiles
WHERE profile_url IN (
  SELECT profile_url
  FROM duplicates
  WHERE row_num > 1
);
-- DELETE 86


select count(*) from therapist_profiles  --Total rows 55053


--Adding new columns
ALTER TABLE therapist_profiles
ADD COLUMN Name TEXT,
ADD COLUMN First_Name TEXT,
ADD COLUMN Last_Name TEXT,
ADD COLUMN Title TEXT,
ADD COLUMN Credential TEXT,
ADD COLUMN Phone TEXT,
ADD COLUMN Availability TEXT,
ADD COLUMN City TEXT,
ADD COLUMN State TEXT,
ADD COLUMN ZIP_Code TEXT,
ADD COLUMN Individual_Sessions TEXT,
ADD COLUMN Couple_Sessions TEXT,
ADD COLUMN Membership TEXT,
ADD COLUMN Certificate TEXT,
ADD COLUMN Attended_University TEXT,
ADD COLUMN "Major/Degree" TEXT,
ADD COLUMN Graduation_Year TEXT,
ADD COLUMN "In_Practice_(years)" TEXT,
ADD COLUMN Age TEXT,
ADD COLUMN Participants TEXT,
ADD COLUMN Communities TEXT,
ADD COLUMN Religion TEXT,
ADD COLUMN Languages_Spoken TEXT

----- EDITING name_header -----

select name_header from  therapist_profiles

UPDATE therapist_profiles
SET 
Name = initcap(split_part(name_header, '|', 1)),
title = initcap(split_part(name_header, '|', 2)),
credential = UPPER(split_part(name_header, '|', 3))

--- Name, Title, Credential are updated
select name, title, credential, name_header 
from therapist_profiles limit 25


----- EDITING location -----

select location 
from therapist_profiles limit 10

UPDATE therapist_profiles
SET 
city = split_part(location, '|',1),
state = UPPER(split_part(location, '|',2)),
zip_code = split_part(location, '|',3),
phone = split_part(location, '|',4),
availability = split_part(location, '|',5);

--- City, State, Zip_code, Availability, Phone are updated
select city, state, zip_code, availability, phone, location 
from therapist_profiles 
limit 25

select state, count(*) as total_therapists
from therapist_profiles
group by state
order by total_therapists desc
--- NY: 14462, TX: 14230, CA:13580 the top 3 counts


----- EDITING sessions -----
select sessions from therapist_profiles

UPDATE therapist_profiles
SET 
individual_sessions = substring(sessions FROM '\$[0-9]+(?=,|$)'),
couple_sessions = substring(sessions FROM '\$[0-9]+$');

select individual_sessions, couple_sessions, sessions 
from therapist_profiles
where individual_sessions != couple_sessions
limit 25

--removing the $ sign
UPDATE therapist_profiles
SET 
  individual_sessions = regexp_replace(individual_sessions, '\$', '', 'g'),
  couple_sessions = regexp_replace(couple_sessions, '\$', '', 'g');


ALTER TABLE therapist_profiles
ALTER COLUMN individual_sessions TYPE INTEGER USING individual_sessions::INTEGER,
ALTER COLUMN couple_sessions TYPE INTEGER USING couple_sessions::INTEGER;


---Finding the max, mean and median of the sessions for the top 4 states with most rows
SELECT 
  state,
  MAX(individual_sessions) AS max_individual_rate,
  ROUND(AVG(individual_sessions),2) AS avg_individual_rate,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY individual_sessions) AS median_individual_rate, 
  MAX(couple_sessions) AS max_couple_rate,
  ROUND(AVG(couple_sessions),2) AS avg_couple_rate,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY couple_sessions) AS median_couple_sessions
FROM therapist_profiles
GROUP BY state
having state in ('TX', 'CA', 'FL', 'NY');

