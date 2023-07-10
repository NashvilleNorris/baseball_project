--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
--original attempt Todd made with team help
SELECT  p.namefirst||' '||p.namelast AS manager_name, a.awardid AS award_name, a.yearid AS year, a.lgid AS league_name, m.teamid AS city
FROM awardsmanagers AS a
INNER JOIN people AS p
ON a.playerid = p.playerid
INNER JOIN managershalf AS m 
ON p.playerid = m.playerid
WHERE a.awardid = 'TSN Manager of the Year'
AND a.lgid IN ('AL','NL')
GROUP BY a.playerid, a.awardid, a.yearid, a.lgid, p.namefirst, p.namelast, m.teamid


--Jeremy's work with team help as well as Dibran's help
WITH both_leagues AS (
	SELECT playerid --COUNT(DISTINCT(lgid)) AS counts
	FROM awardsmanagers
	WHERE awardid = 'TSN Manager of the Year'
	AND lgid IN ('AL','NL')
	GROUP BY playerid
	HAVING COUNT(DISTINCT(lgid)) = 2
	ORDER BY COUNT(DISTINCT(lgid)) DESC
	)
	,
	award_year AS (
	SELECT DISTINCT am.yearid, am.playerid
	FROM both_leagues AS bl
	INNER JOIN awardsmanagers AS am
	USING (playerid)
	--WHERE playerid IN ('johnsda02','leylaji99')
	--AND awardid = 'TSN Manager of the Year'
	)
	
SELECT namefirst|| ' ' || namelast AS manager_name, m.teamid AS team, m.yearid AS season, m.lgid AS league
FROM people AS p
INNER JOIN award_year AS ay
USING (playerid)
INNER JOIN managers AS m
ON ay.playerid = m.playerid AND ay.yearid = m.yearid