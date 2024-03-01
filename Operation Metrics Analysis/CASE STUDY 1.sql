use jobs;
select * from `sql project-1 table`;

/*1. Calculate the number of jobs reviewed per hour per day for November 2020?*/
select ds, round(1.0*count(job_id)*3600/sum(time_spent),2) as num_of_jobs
from `sql project-1 table` where event in ('transfer','decision','skip') and ds between
'2020-11-01' and '2020-11-30' group by ds;

/*Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7-day rolling and why?*/
with cte as(select ds, count(job_id) as 7_days_rolling, sum(time_spent) as total_time from `sql project-1 table`
where event in ('transfer','decision','skip') and ds between '2020-11-01' AND '2020-11-30' GROUP BY ds)
SELECT ds, ROUND(1.0* 
SUM(7_days_rolling) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) / 
SUM(total_time) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS 7d FROM CTE;

/*Calculate the percentage share of each language in the last 30 days?*/
with cte as(SELECT Language, COUNT(job_id) AS num_jobs FROM `sql project-1 table` 
WHERE event IN('transfer','decision','skip') 
AND ds BETWEEN '2020-11-01' AND '2020-11-30' GROUP BY language),  
total AS (SELECT COUNT(job_id)AS total_jobs FROM `sql project-1 table` WHERE event IN('transfer','decision','skip') 
AND ds BETWEEN '2020-11-01' AND '2020-11-30' GROUP BY language)
SELECT language, ROUND(100.0*num_jobs/total_jobs,2) AS perc_jobs FROM CTE ORDER BY perc_job DESC;

/*Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?*/ 
WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY ds, job_id, actor_id) AS rownum FROM `sql project-1 table`)
DELETE FROM CTE WHERE rownum > 1