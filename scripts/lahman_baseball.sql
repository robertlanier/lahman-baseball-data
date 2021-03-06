-- 1. What range of years for baseball games played does the provided database cover? 1871 - 2016

SELECT 	MIN(yearid), -- 1871
		MAX(yearid)  -- 2016
FROM teams; -- yearly stats and standings


/* 2. Name and height of the shortest player in the database. Eddie Gaedel height 43
How many games did he play in? 1 game
What is the name of the team for which he played? St. Louis Browns */

SELECT	DISTINCT
		p.nameFirst,
		p.nameLast,
		p.height,
		t.name,
		a.g_all
FROM people AS p -- Player names, DOB, and biographical info
LEFT JOIN appearances AS a -- details on the positions a player appeared at
ON p.playerid = a.playerid
LEFT JOIN teams AS t -- yearly stats and standings
ON a.teamid = t.teamid
WHERE height =
		(SELECT MIN(height)
		FROM people);


/* 3. Find all players in the database who played at Vanderbilt University.
Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues.
Sort this list in descending order by the total salary earned.
Which Vanderbilt player earned the most money in the majors? */

SELECT	p.nameFirst AS first_name,
		p.nameLast AS last_name,
		SUM(DISTINCT sal.salary) AS total_salary_earned
FROM people AS p -- biological info
LEFT JOIN collegeplaying AS c -- college info
ON p.playerid = c.playerid
LEFT JOIN schools AS s -- college names
ON c.schoolid = s.schoolid
LEFT JOIN salaries AS sal -- salary info
ON p.playerid = sal.playerid
WHERE schoolname = 'Vanderbilt University'
		AND sal.salary IS NOT NULL
GROUP BY p.playerid
ORDER BY SUM(sal.salary) DESC;


/* 4. Using the fielding table, group players into three groups based on their position:
label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
and those with position "P" or "C" as "Battery".
Determine the number of putouts made by each of these three groups in 2016. */

SELECT 	CASE WHEN pos = 'OF' THEN 'Outfield' -- Outfield total putouts 29560
			 WHEN pos = 'P' THEN 'Battery' -- Battery total putouts 41424
			 WHEN pos = 'C' THEN 'Battery'
			 ELSE 'Infield' END AS player_groups, -- Infield total putouts 58934
		SUM(po) AS total_putouts
FROM fielding
WHERE yearid = 2016
GROUP BY player_groups
ORDER BY total_putouts DESC;


/* 5. Find the average number of strikeouts per game by decade since 1920.
Round the numbers you report to 2 decimal places.
Do the same for home runs per game. Do you see any trends? */

SELECT 	ROUND(SUM(so)::numeric/SUM(g), 2) AS avg_so_per_g, -- Average strikeouts per game
		ROUND(SUM(hr)::numeric/SUM(g), 2) AS avg_hr_per_g, -- Average strikeouts per game
		yearid/10 * 10 AS decade
		/*CASE
			WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
			WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
			WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
			WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
			WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
			WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
			WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
			WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
			WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
			WHEN yearid BETWEEN 2010 AND 2019 THEN '2010s'
			ELSE 'Before 1920s' END AS decade */
FROM teams -- yearly stats and standings
WHERE yearid >= 1920
GROUP BY decade
ORDER BY decade;


/* 6. Find the player who had the most success stealing bases in 2016, 
where success is measured as the percentage of stolen base attempts which are successful.
(A stolen base attempt results either in a stolen base or being caught stealing.)
Consider only players who attempted at least 20 stolen bases.
ANS: Larry Gardner at 87% */

SELECT	p.nameFirst,
		p.nameLast,
		b.sb, -- Successful stolen bases
		ROUND(b.sb::numeric / (b.sb + b.cs), 2) AS perc_stolen_success
FROM batting AS b -- post-season batting stats
LEFT JOIN people AS p -- player bio
ON b.playerid = p.playerid
WHERE b.sb + b.cs >= 20 AND b.yearid = '2016'-- players who attempted at least 20 stolen bases in 2016
	AND ROUND(b.sb::numeric / (b.sb + b.cs), 2) = 
		(SELECT MAX(ROUND(sb::numeric / (sb + cs), 2))
			FROM batting
			WHERE sb + cs >= 20 AND yearid = '2016'); --players who attempted at least 20 stolen bases in 2016


/* 7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?
What is the smallest number of wins for a team that did win the world series?
Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case.
Then redo your query, excluding the problem year.
How often from 1970 – 2016 was it the case that a team with the most wins also won the world series?
What percentage of the time? */




/* 8. Using the attendance figures from the homegames table,
find the teams and parks which had the top 5 average attendance per game in 2016
(where average attendance is defined as total attendance divided by number of games).
Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance.
Repeat for the lowest 5 average attendance. */



/* 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)?
Give their full name and the teams that they were managing when they won the award.  */