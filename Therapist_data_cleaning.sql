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

------------------------------
UPDATE therapist_profiles
SET Name = initcap(split_part(name_header, '|', 1));
-- capitalized the first letter of the name and family name;


