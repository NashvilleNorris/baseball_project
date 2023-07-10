--7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

--From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?
SELECT teamid AS team, yearid AS season, MAX(w) AS total_wins
	--CASE WHEN wswin = 'Y' AND w = 'MAX(wins)' THEN 1
	--ELSE 0 END AS count_years
	FROM teams
	WHERE wswin = 'N'
	AND yearid BETWEEN 1970 AND 2016
	GROUP BY yearid, teamid
	ORDER BY total_wins DESC
	LIMIT 1
--SEA Mariners in 2001 won 116 games but lost the WS



--What is the smallest number of wins for a team that did win the world series?
SELECT name AS team_name, SUM(w) AS number_of_wins, yearid AS season
FROM teams
WHERE yearid <= 2016
	AND yearid >= 1970
	AND wswin = 'Y'
	AND yearid NOT IN (1981) --this doesn't change the result-------
GROUP BY name, yearid
ORDER BY number_of_wins ASC
LIMIT 1;
--83 wins for the St Louis Cards in 2006

--Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case.
SELECT name AS team_name, SUM(w) AS wins, yearid AS season
FROM teams
WHERE yearid <= 2016
	AND yearid >= 1970
	AND wswin = 'Y'
GROUP BY name, yearid
ORDER BY wins ASC;
--Above pulls yearid's for wins and we can see low wins per year 1981; That season there was a strike and the season was shortened


--how often did the team with the most wins win world series?
--team with most wins that has won WS
SELECT name AS team_name, SUM(w) AS wins, yearid AS season
FROM teams
WHERE yearid <= 2016
	AND yearid >= 1970
	AND wswin = 'Y'
	AND yearid NOT IN (1981)
GROUP BY name, yearid
ORDER BY yearid DESC


--How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
WITH most_wins AS (
 	SELECT
 		yearid,
 		MAX(w) AS w
 	FROM teams
 	WHERE yearid >= 1970
 	GROUP BY yearid
 	ORDER BY yearid
 	),
 most_win_teams AS (
 	SELECT 
 		yearid,
 		name,
 		wswin
 	FROM teams
 	INNER JOIN most_wins
 	USING(yearid, w)
 )
 SELECT 
 	(SELECT COUNT(*)
 	 FROM most_win_teams
 	 WHERE wswin = 'Y'
 	) * 100.0 /
 	(SELECT COUNT(*)
 	 FROM most_win_teams
 	);


--from Ed
WITH managerid AS(
		SELECT 	yearid,
				playerid,
	   			lgid
FROM awardsmanagers
WHERE playerid IN (SELECT 	playerid
					FROM awardsmanagers
					WHERE awardid = 'TSN Manager of the Year'
					AND lgid = 'NL' 
					INTERSECT
					SELECT 	playerid
					FROM awardsmanagers
					WHERE awardid = 'TSN Manager of the Year'
					AND lgid = 'AL')
					AND awardid = 'TSN Manager of the Year'
ORDER BY yearid
)
-- Jim Leyland Won the Award in 1988, 1990, 1992, and 2006 / Davey Johnson won the award in 1997 and 2012
SELECT 	m1.yearid,
		CONCAT(p.namefirst, ' ', p.namelast) AS manager_name,
		m1.lgid,
		m2.teamid,
		t.name
FROM managerid AS m1
INNER JOIN people AS p USING(playerid)
INNER JOIN managers AS m2 ON m1.playerid = m2.playerid 
							AND m1.yearid = m2.yearid
							AND p.playerid = m2.playerid
INNER JOIN teams AS t ON m1.yearid = t.yearid
						AND m2.yearid = t.yearid
						AND m2.teamid = t.teamid