SELECT * FROM hr_analysis.ds;
ALTER TABLE hr_analysis.ds
CHANGE COLUMN ï»¿id emp_id VARCHAR(20);
UPDATE hr_analysis.ds
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
SELECT * FROM hr_analysis.ds;
ALTER TABLE hr_analysis.ds
MODIFY COLUMN birthdate DATE;
DESCRIBE hr_analysis.ds;
SELECT * FROM hr_analysis.ds;
UPDATE hr_analysis.ds
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
ALTER TABLE hr_analysis.ds
MODIFY COLUMN hire_date DATE;
DESCRIBE hr_analysis.ds;
SELECT * FROM hr_analysis.ds;
SELECT termdate FROM hr_analysis.ds;
UPDATE hr_analysis.ds
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';
SELECT termdate FROM hr_analysis.ds;
DESCRIBE hr_analysis.ds;
ALTER TABLE hr_analysis.ds ADD COLUMN age INT;
UPDATE hr_analysis.ds
SET age = timestampdiff(YEAR,birthdate,CURDATE());
SELECT birthdate,age FROM hr_analysis.ds;
SELECT min(age) AS youngest, max(age) AS oldest FROM hr_analysis.ds;
SELECT count(*) FROM hr_analysis.ds WHERE age < 1;
SELECT gender, count(*) AS count from hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP BY gender;
SELECT race, count(*) AS count FROM hr_analysis.ds WHERE age>=1 AND termdate = '' GROUP BY race ORDER BY count(*) DESC;
SELECT min(age) AS youngest, max(age) AS oldest FROM hr_analysis.ds WHERE age>=1 AND termdate = '';	
SELECT 
	CASE
		WHEN age >=18 AND age <=24 THEN '18-24'
        WHEN age >=25 AND age <=34 THEN '25-34'
        WHEN age >=35 AND age <=44 THEN '35-44'
        WHEN age >=45 AND age <=54 THEN '45-54'
        WHEN age >=55 AND age <=64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) AS count
FROM hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP by age_group
ORDER BY age_group ASC;
SELECT 
	CASE
		WHEN age >=18 AND age <=24 THEN '18-24'
        WHEN age >=25 AND age <=34 THEN '25-34'
        WHEN age >=35 AND age <=44 THEN '35-44'
        WHEN age >=45 AND age <=54 THEN '45-54'
        WHEN age >=55 AND age <=64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    count(*) AS count
FROM hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP by age_group, gender
ORDER BY age_group, gender ASC;
SELECT Location, count(*) AS count
FROM hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP BY Location;
SELECT 
	ROUND(AVG(datediff(termdate,hire_date))/365,0) AS avg_length_of_employment
FROM hr_analysis.ds
WHERE termdate <=curdate() AND termdate <> '' AND age >= 18;
SELECT gender, department, jobtitle, COUNT(*) AS count
FROM hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP BY gender, department, jobtitle
ORDER BY department, jobtitle DESC;
SELECT jobtitle, COUNT(*) AS count
FROM hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP BY jobtitle
ORDER BY jobtitle DESC;
DESCRIBE hr_analysis.ds;
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM(
	SELECT department,
    COUNT(*) AS total_count,
    SUM(CASE WHEN termdate != '' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr_analysis.ds
    WHERE age >=18
    GROUP BY department) AS subquery
ORDER BY termination_rate DESC;
SELECT location_city, location_state,
COUNT(*) AS count
FROM hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP BY location_city, location_state
ORDER BY location_city, location_state DESC;
SELECT location_state,
COUNT(*) AS count
FROM hr_analysis.ds
WHERE age>=1 AND termdate = ''
GROUP BY location_state
ORDER BY count DESC;
SELECT
	year,
    hires,
    terminations,
    hires-terminations AS net_change,
    round((hires-terminations)/hires *100,2) AS net_change_percent
FROM(
	SELECT
		YEAR(hire_date) AS year,
        count(*) AS hires,
        SUM(CASE WHEN termdate != '' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
        FROM hr_analysis.ds
        WHERE age >=18
        GROUP BY year) AS subquery
ORDER BY year ASC;
SELECT department, round(avg(datediff(termdate,hire_Date)/365),0) AS avg_tenure
FROM hr_analysis.ds
WHERE termdate != '' AND age >=18 AND termdate <= curdate()
GROUP BY department
ORDER BY department ASC;
        


    
 

	



