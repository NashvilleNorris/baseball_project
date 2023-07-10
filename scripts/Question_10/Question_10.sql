--10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.
--via Todd
SELECT p.namefirst|| ' ' ||p.namelast AS player_name, b.teamid AS team, b.yearid AS season, b.hr AS homeruns_hit, CAST(LEFT(p.debut, 4) AS INT) AS debut_season
FROM people AS p
INNER JOIN batting as b
ON p.playerid = b.playerid
WHERE b.yearid = '2016'
AND b.hr >= 1
AND CAST(LEFT(p.debut, 4) AS INT) < 2006
ORDER BY b.hr DESC

--via Dibran
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