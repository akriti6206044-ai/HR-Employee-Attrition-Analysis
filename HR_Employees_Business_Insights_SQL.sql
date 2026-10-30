-- HR EMPLOYEE ANALYSIS: KPI, TRENDS & BUSINESS INSIGHTS
-- Table: hr_employees
-- PostgreSQL syntax. For MySQL, replace EXTRACT/YEAR functions as needed.

-- 1. EXECUTIVE KPI
SELECT COUNT(*) AS total_employees,
       ROUND(AVG("Salary"),2) AS avg_salary,
       ROUND(AVG("Experience_Years"),2) AS avg_experience,
       ROUND(AVG("Performance_Rating"),2) AS avg_performance,
       ROUND(AVG("Job_Satisfaction"),2) AS avg_satisfaction,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate,
       ROUND(100.0*SUM(CASE WHEN "Overtime"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS overtime_rate
FROM hr_employees;

-- 2. DEPARTMENT SCORECARD
SELECT "Department", COUNT(*) AS employees,
       ROUND(AVG("Salary"),2) AS avg_salary,
       ROUND(AVG("Performance_Rating"),2) AS avg_performance,
       ROUND(AVG("Job_Satisfaction"),2) AS avg_satisfaction,
       ROUND(AVG("Absenteeism_Days"),2) AS avg_absenteeism,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY "Department"
ORDER BY attrition_rate DESC;

-- 3. ATTRITION BY DEPARTMENT
SELECT "Department", COUNT(*) AS employees,
       SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END) AS employees_left,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY "Department"
ORDER BY attrition_rate DESC;

-- 4. ATTRITION VS OVERTIME
SELECT "Overtime", COUNT(*) AS employees,
       SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END) AS employees_left,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate,
       ROUND(AVG("Job_Satisfaction"),2) AS avg_satisfaction
FROM hr_employees
GROUP BY "Overtime";

-- 5. ATTRITION VS SATISFACTION
SELECT "Job_Satisfaction", COUNT(*) AS employees,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY "Job_Satisfaction"
ORDER BY "Job_Satisfaction";

-- 6. ATTRITION VS WORK-LIFE BALANCE
SELECT "Work_Life_Balance", COUNT(*) AS employees,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY "Work_Life_Balance"
ORDER BY "Work_Life_Balance";

-- 7. AGE GROUP ANALYSIS
SELECT CASE
         WHEN "Age" < 25 THEN '21-24'
         WHEN "Age" BETWEEN 25 AND 29 THEN '25-29'
         WHEN "Age" BETWEEN 30 AND 34 THEN '30-34'
         WHEN "Age" BETWEEN 35 AND 39 THEN '35-39'
         WHEN "Age" BETWEEN 40 AND 49 THEN '40-49'
         ELSE '50+'
       END AS age_group,
       COUNT(*) AS employees,
       ROUND(AVG("Salary"),2) AS avg_salary,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY 1
ORDER BY 1;

-- 8. SALARY BY DEPARTMENT
SELECT "Department", MIN("Salary") AS min_salary,
       ROUND(AVG("Salary"),2) AS avg_salary,
       MAX("Salary") AS max_salary
FROM hr_employees
GROUP BY "Department"
ORDER BY avg_salary DESC;

-- 9. SALARY BY JOB ROLE
SELECT "Job_Role", COUNT(*) AS employees,
       ROUND(AVG("Salary"),2) AS avg_salary,
       ROUND(AVG("Experience_Years"),2) AS avg_experience
FROM hr_employees
GROUP BY "Job_Role"
ORDER BY avg_salary DESC;

-- 10. EXPERIENCE VS SALARY
SELECT "Experience_Years", COUNT(*) AS employees,
       ROUND(AVG("Salary"),2) AS avg_salary
FROM hr_employees
GROUP BY "Experience_Years"
ORDER BY "Experience_Years";

-- 11. PERFORMANCE & TRAINING
SELECT "Performance_Rating", COUNT(*) AS employees,
       ROUND(AVG("Training_Hours"),2) AS avg_training_hours,
       ROUND(AVG("Salary"),2) AS avg_salary,
       ROUND(AVG("Job_Satisfaction"),2) AS avg_satisfaction
FROM hr_employees
GROUP BY "Performance_Rating"
ORDER BY "Performance_Rating";

-- 12. ABSENTEEISM BY DEPARTMENT
SELECT "Department", COUNT(*) AS employees,
       ROUND(AVG("Absenteeism_Days"),2) AS avg_absenteeism,
       MAX("Absenteeism_Days") AS max_absenteeism
FROM hr_employees
GROUP BY "Department"
ORDER BY avg_absenteeism DESC;

-- 13. EDUCATION ANALYSIS
SELECT "Education", COUNT(*) AS employees,
       ROUND(AVG("Salary"),2) AS avg_salary,
       ROUND(AVG("Performance_Rating"),2) AS avg_performance
FROM hr_employees
GROUP BY "Education"
ORDER BY avg_salary DESC;

-- 14. LOCATION ANALYSIS
SELECT "Location", COUNT(*) AS employees,
       ROUND(AVG("Salary"),2) AS avg_salary,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY "Location"
ORDER BY employees DESC;

-- 15. YEARLY HIRING TREND
SELECT EXTRACT(YEAR FROM "Joining_Date") AS joining_year,
       COUNT(*) AS employees_joined,
       ROUND(AVG("Salary"),2) AS avg_salary
FROM hr_employees
GROUP BY 1
ORDER BY 1;

-- 16. MONTHLY HIRING TREND
SELECT DATE_TRUNC('month',"Joining_Date") AS hiring_month,
       COUNT(*) AS employees_joined
FROM hr_employees
GROUP BY 1
ORDER BY 1;

-- 17. YEAR-OVER-YEAR HIRING TREND
WITH yearly AS (
    SELECT EXTRACT(YEAR FROM "Joining_Date") AS year,
           COUNT(*) AS hires
    FROM hr_employees
    GROUP BY 1
)
SELECT year, hires,
       LAG(hires) OVER (ORDER BY year) AS previous_year,
       hires-LAG(hires) OVER (ORDER BY year) AS yoy_change
FROM yearly
ORDER BY year;

-- 18. TOP 10 HIGH-PAID EMPLOYEES
SELECT "Employee_ID","Department","Job_Role","Salary","Experience_Years","Performance_Rating"
FROM hr_employees
ORDER BY "Salary" DESC
LIMIT 10;

-- 19. HIGH-PERFORMANCE EMPLOYEES
SELECT "Employee_ID","Department","Job_Role","Salary","Performance_Rating","Training_Hours"
FROM hr_employees
WHERE "Performance_Rating" >= 4
ORDER BY "Performance_Rating" DESC,"Salary" DESC;

-- 20. HR ATTENTION SEGMENT
SELECT "Employee_ID","Department","Job_Role","Job_Satisfaction",
       "Work_Life_Balance","Overtime","Absenteeism_Days","Attrition",
       CASE
         WHEN "Attrition"='Yes' THEN 'Already Left'
         WHEN "Job_Satisfaction"<=2 AND "Work_Life_Balance"<=2 AND "Overtime"='Yes' THEN 'High Attention'
         WHEN "Job_Satisfaction"<=2 OR "Work_Life_Balance"<=2 OR "Overtime"='Yes' THEN 'Needs Attention'
         ELSE 'Lower Attention'
       END AS attention_group
FROM hr_employees;

-- 21. DASHBOARD: DEPARTMENT SCORECARD
SELECT "Department", COUNT(*) AS employees,
       ROUND(AVG("Salary"),0) AS avg_salary,
       ROUND(AVG("Performance_Rating"),2) AS avg_performance,
       ROUND(AVG("Job_Satisfaction"),2) AS avg_satisfaction,
       ROUND(AVG("Training_Hours"),1) AS avg_training,
       ROUND(AVG("Absenteeism_Days"),1) AS avg_absenteeism,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY "Department";

-- 22. DASHBOARD: ATTRITION DRIVERS
SELECT "Department","Overtime","Job_Satisfaction","Work_Life_Balance",
       COUNT(*) AS employees,
       ROUND(100.0*SUM(CASE WHEN "Attrition"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
FROM hr_employees
GROUP BY "Department","Overtime","Job_Satisfaction","Work_Life_Balance"
ORDER BY attrition_rate DESC;

-- 23. DATA QUALITY CHECK
SELECT COUNT(*) AS total_rows,
       SUM(CASE WHEN "Employee_ID" IS NULL THEN 1 ELSE 0 END) AS missing_id,
       SUM(CASE WHEN "Department" IS NULL THEN 1 ELSE 0 END) AS missing_department,
       SUM(CASE WHEN "Salary" IS NULL THEN 1 ELSE 0 END) AS missing_salary,
       SUM(CASE WHEN "Joining_Date" IS NULL THEN 1 ELSE 0 END) AS missing_joining_date
FROM hr_employees;

-- ============================================================
-- POWER BI DASHBOARD PLAN
-- Page 1: HR Overview -> KPI cards, employees by department,
--         salary by department, attrition by department.
-- Page 2: Attrition -> overtime, satisfaction, work-life,
--         age group and department attrition.
-- Page 3: Salary -> department, role, experience vs salary.
-- Page 4: Performance -> performance, training, satisfaction,
--         absenteeism.
-- Page 5: Hiring Trends -> yearly hires, monthly hires, YoY change.
--
-- BUSINESS QUESTIONS:
-- 1. Which department has the highest attrition?
-- 2. Is overtime associated with higher attrition?
-- 3. Which satisfaction level has the highest attrition?
-- 4. Which department/job role has the highest salary?
-- 5. Which departments have high absenteeism?
-- 6. Does training differ across performance groups?
-- 7. How has hiring changed over time?
-- 8. Which employee groups need HR attention?
--
-- These queries show associations/patterns; they do not prove causation.
-- ============================================================
