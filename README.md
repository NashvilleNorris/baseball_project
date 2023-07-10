## Lahman Baseball Database Exercise
- this data has been made available [online](http://www.seanlahman.com/baseball-archive/statistics/) by Sean Lahman
- A data dictionary is included with the files for this project.

		--What range of years for baseball games played does the provided database cover? 
SELECT MIN(yearid) AS earliest_year, MAX(yearid) AS latest_year

FROM appearances
		--1871 to 2016

		--Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT namefirst AS first_name, namelast AS last_name, height

FROM people

ORDER BY height 
		--Eddie Gaedel at 43 units  

		--How many games did he play in?
SELECT p.namefirst AS first_name, p.namelast AS last_name, a.G_all AS total_games_played

FROM people AS p

INNER JOIN appearances AS a

ON p.playerid = a.playerid

WHERE p.namelast = 'Gaedel'
		-- 1 game

--Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
	
--Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.


--Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
   

--Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
	

		--From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
SELECT teamid AS team, yearid AS season, MAX(w) AS total_wins
	--CASE WHEN wswin = 'Y' AND w = 'MAX(wins)' THEN 1
	--ELSE 0 END AS count_years
	FROM teams
	WHERE wswin = 'N'
	AND yearid BETWEEN 1970 AND 2016
	GROUP BY yearid, teamid
	ORDER BY total_wins DESC
	LIMIT 1
		--SEA Mariners in 2001 won 116 games but did not win the WS

		--Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case.
SELECT name AS team_name, SUM(w) AS number_of_wins, yearid AS season
FROM teams
WHERE yearid <= 2016
	AND yearid >= 1970
	AND wswin = 'Y'
	AND yearid NOT IN (1981) --this doesn't change the result-------
GROUP BY name, yearid
ORDER BY number_of_wins ASC
LIMIT 1;
		--83 wins for the St Louis Cards in 2006; the 81 Dodgers won the WS in a shortened season due to strike

		--Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
		--Find the teams and parks which had the top 5 average attendance per game in 2016. Report the park name, team name, and average attendance.
SELECT park_name, team, SUM(attendance)/SUM(games) AS avg_attendance 
FROM homegames
INNER JOIN parks
USING (park)
WHERE year=2016
AND games >= 10
GROUP BY team, park_name
ORDER BY avg_attendance DESC
LIMIT 5 

		--Repeat for the lowest 5 average attendance. Report the park name, team name, and average attendance.
SELECT park_name, team, SUM(attendance)/SUM(games) AS avg_attendance 
FROM homegames
INNER JOIN parks
USING (park)
WHERE year=2016
AND games >= 10
GROUP BY team, park_name
ORDER BY avg_attendance
LIMIT 5

		--Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

WITH full_batting AS (
	SELECT
		playerid,
		yearid,
		SUM(hr) AS hr
	FROM batting
	GROUP BY playerid, yearid
)
,
decaders AS (
	SELECT
		playerid
	FROM full_batting
	GROUP BY playerid
	HAVING COUNT(*) >= 10
),
eligible_players AS (
	SELECT
		playerid,
		hr
	FROM decaders
	INNER JOIN full_batting
	USING(playerid)
	WHERE yearid = 2016 AND hr >= 1
),
career_bests AS (
	SELECT
		playerid,
		MAX(hr) AS hr
	FROM full_batting
	GROUP BY playerid
)
SELECT
	namefirst || ' ' || namelast AS full_name,
	hr
FROM eligible_players
JOIN career_bests
USING (playerid, hr)
INNER JOIN people
USING(playerid);

		--Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

WITH full_batting AS (
	SELECT
		playerid,
		yearid,
		SUM(hr) AS hr
	FROM batting
	GROUP BY playerid, yearid
)
,
decaders AS (
	SELECT
		playerid
	FROM full_batting
	GROUP BY playerid
	HAVING COUNT(*) >= 10
),
eligible_players AS (
	SELECT
		playerid,
		hr
	FROM decaders
	INNER JOIN full_batting
	USING(playerid)
	WHERE yearid = 2016 AND hr >= 1
),
career_bests AS (
	SELECT
		playerid,
		MAX(hr) AS hr
	FROM full_batting
	GROUP BY playerid
)
SELECT
	namefirst || ' ' || namelast AS full_name,
	hr
FROM eligible_players
JOIN career_bests
USING (playerid, hr)
INNER JOIN people
USING(playerid);
