use users;
select * from users.`table-1 users`;
select * from users.`table-2 events`;
select * from users.`table-3 email_event`;

/*Calculate the weekly user engagement?*/
SELECT date_trunc('week', e.occurred_at), COUNT(DISTINCT e.user_id) AS weekly_active_users 
FROM `table-2 events` e WHERE e.event_type = 'engagement' AND e.event_name = 'login' GROUP BY 1  ORDER BY 1;

/*Calculate the user growth for product?*/
SELECT DATE_TRUNC('day', created_at) AS day, COUNT(*) AS all_users, COUNT(CASE WHEN activated_at IS NOT NULL
THEN u.user_id ELSE NULL END) AS activated_users FROM `table-1 users` u
WHERE created_at >= ‘2021-04-01’ AND created_at < ‘2021-04-30’ GROUP BY 1 ORDER BY 1;

/* Calculate the weekly retention of users-sign up cohort?*/

SELECT DATE_TRUNC(‘week’, z.occurred_at) AS “week”, AVG(z.age_at_event) AS “Average_age”, COUNT(DISTINCT CASE WHEN z.user_age > 70 
THEN z.user_id ELSE NULL) AS “10+ weeks”, COUNT(DISTINCT CASE WHEN z.user_age < 70 AND z.user_age >=63 THEN z.user_id ELSE NULL END) AS ‘9 weeks”, COUNT(DISTINCT CASE WHEN z.user_age < 63 AND z.user_age >=56THEN z.user_id ELSE NULL END) AS ‘8 weeks”, 
COUNT(DISTINCT CASE WHEN z.user_age < 56 AND z.user_age >=49 THEN z.user_id ELSE NULL END) AS ‘7 weeks”,  
COUNT(DISTINCT CASE WHEN z.user_age < 49 AND z.user_age >=42 THEN z.user_id ELSE NULL END) AS ‘6 weeks”,  
COUNT(DISTINCT CASE WHEN z.user_age < 42 AND z.user_age >=35 THEN z.user_id ELSE NULL END) AS ‘5 weeks”,  COUNT(DISTINCT CASE WHEN z.user_age < 35 AND z.user_age >=28 THEN z.user_id ELSE NULL END) AS ‘4 weeks”, 
COUNT(DISTINCT CASE WHEN z.user_age < 28 AND z.user_age >=21 THEN z.user_id ELSE NULL END) AS ‘3 weeks”,  COUNT(DISTINCT CASE WHEN z.user_age < 21 AND z.user_age >=14 THEN z.user_id ELSE NULL END) AS ‘2 weeks”,  
COUNT(DISTINCT CASE WHEN z.user_age < 14 AND z.user_age >=7 THEN z.user_id ELSE NULL END) AS ‘1 weeks”,  COUNT(DISTINCT CASE WHEN z.user_age < 7 AND z.user_age >=63 THEN z.user_id ELSE NULL END) AS ‘Less than a week”, 
FROM( SELECT e.occurred_at, u.user_id, DATE_TRUNC(“week”,u.activated_at) AS activation_week, EXTRACT(‘day’ FROM e.occurred_at – u.activated_at) AS age_at_event, EXTRACT(‘day’ FROM ‘201-09-01’::TIMESTAMP –  u.activated_at) AS user_age 
FROM tutorial.yammer_users u JOIN tutorial.yammer_events e ON e.user_id = u.user_id AND e.event_type = ‘engagement’ AND e.evnetn_name= ‘login’ AND e.occurred_at >= ‘2014-05-01’ AND e.occurred_at < ‘2014-09-01’ WHERE u.activated_at IS NOT NULL ) z GROUP BY 1 ORDER BY 1  LIMIT 100;

/*Calculate the weekly engagement per device?*/
SELECT date_trunc('week', occurred_at) AS week, COUNT(DISTINCT e.user_id) AS weekly_active_users, COUNT(DISTINCT CASE WHEN e.device 
IN('macbook pro','lenovo thinkpad','macbook air','dell inspiron notebook','asus chromebook','dell inspiron desktop','acer aspire notebook','hp pavilion desktop','acer aspire desktop','mac mini')
THEN e.user_id ELSE NULL END) AS computer,
COUNT(DISTINCT CASE WHEN e.device IN('iphone 5','samsung galaxy s4','nexus 5','iphone 5s','iphone 4s','nokia lumia 635','htc one','samsung galaxy note','amazon fire phone') THEN e.user_id ELSE NULL END) AS phone, 
COUNT(DISTINCT CASE WHEN e.device IN('ipad air','nexus 7','ipad mini','nexus 10','kindle fire','windows surface','samsung galaxy tablet') THEN e.user_id ELSE NULL END) AS  tablet FROM `table-2 events` e WHERE e.event_type = 'engagement' AND e.event_name = 'login' GROUP BY 1  ORDER BY 1 LIMIT 100;


/*Calculate the email engagement metrics?*/
SELECT DATE_TRUNC(‘week’, occurred_at) AS week, COUNT(CASE WHEN e.action = 'sent weekly digest' THEN e.user id ELSE NULL END) AS weekly emails, COUNT(CASE WHEN e.action = ‘sent reengagement email’ THEN e.user id ELSE NULL END) AS reengagement emails, 
COUNT(CASE WHEN e.action = ‘email open’ THEN e.user id ELSE NULL END) AS email opens, COUNT(CASE WHEN e.action = ‘email clickthrough’ THEN e.user id  ELSE NULL END) AS email clickthroughs  FROM email events e GROUP BY 1