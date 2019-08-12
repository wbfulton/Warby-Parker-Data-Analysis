-- Quiz Funnel
-- gets the most common response for each question
WITH responses AS ( 
  SELECT question, 
  	response, 
  	COUNT(*) AS 'times_selected'
  FROM survey
  GROUP BY 2
	ORDER BY 3 DESC )
SELECT question, 
	response,
  MAX(times_selected) AS 'times selected'
FROM responses
GROUP BY 1;

-- selects the # of people who responded to each question
SELECT question, COUNT( DISTINCT user_id ) AS 'count'
FROM survey
GROUP BY 1;

-- compares conversions in funnel
WITH funnels AS (
  SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
  	h.number_of_pairs,
  	p.user_id iS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT COUNT(*) AS 'num_quiz',
	SUM(is_home_try_on) AS 'num_try_on', 
  SUM(is_purchase) AS 'num_purchase'
FROM funnels;

-- compares the purchase rate between different amount of clothes tried on
WITH funnels AS (
  SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
  	h.number_of_pairs AS 'num_pairs',
  	p.user_id iS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
  	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT num_pairs,
  SUM(is_home_try_on) AS 'num_try_on',
  SUM(is_purchase) AS 'num_purchase',
  ROUND(1.0 * SUM(is_home_try_on) / COUNT(user_id) * 100.0, 2) AS '% quiz to try on',
  ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on) * 100.0, 2) AS '% try on to purchase'
FROM funnels
GROUP BY num_pairs HAVING num_pairs NOT NULL;

-- selects most popular style
SELECT style, COUNT(*) AS '# sold'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

-- selects most popular models
SELECT model_name, style, COUNT(*) AS '# sold'
FROM purchase
GROUP BY 1
ORDER BY 3 DESC;