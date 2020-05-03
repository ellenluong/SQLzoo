-- Part 1: 
-- The data is available (mysql format) at http://sqlzoo.net/euro2012.sql
-- 1. Show the matchid and player name for all goals scored by Germany
SELECT matchid, player
FROM goal
WHERE teamid = 'GER'

-- 2. Show id, stadium, team1, team2 for just game 1012
SELECT id, stadium, team1, team2
FROM game
WHERE id = 1012

-- 3. Show the player, teamid, stadium and mdate for every German goal
SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON (id=matchid)
WHERE teamid = 'GER'

-- 4. Show the team1, team2 and player for every goal scored 
-- by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
FROM game JOIN goal ON (id=matchid)
WHERE player LIKE 'Mario%'

-- 5. Show player, teamid, coach, gtime for all goals scored 
-- in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON teamid=id
WHERE gtime<=10

-- 6. List the dates of the matches and the name of the team 
-- in which 'Fernando Santos' was the team1 coach
SELECT mdate, teamname
FROM game JOIN eteam ON team1=eteam.id
WHERE coach = 'Fernando Santos'

-- 7. List the player for every goal scored in a game 
-- where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal JOIN game ON goal.matchid=game.id
WHERE stadium = 'National Stadium, Warsaw'

-- 8. Show the name of all players who scored a goal against Germany
SELECT DISTINCT player
FROM game JOIN goal ON matchid = id
WHERE (team1='GER' OR team2='GER') AND teamid!='GER'

-- 9. Show teamname and the total number of goals scored
SELECT teamname, count(player) AS No_of_score
FROM eteam JOIN goal ON id=teamid
GROUP BY teamname

-- 10. Show the stadium and the number of goals scored in each stadium
SELECT stadium, COUNT(id)
FROM game JOIN goal ON id=matchid
GROUP BY stadium

-- 11. For every match involving 'POL',
-- show the matchid, date and the number of goals scored
SELECT matchid, mdate, COUNT(player) AS goals
FROM game JOIN goal ON game.id=goal.matchid
WHERE team1='POL' OR team2='POL'
GROUP BY matchid

-- 12. For every match where 'GER' scored, 
-- show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(teamid) AS goals
FROM game JOIN goal ON game.id=goal.matchid
WHERE teamid='GER'
GROUP BY matchid

-- 13. List every match with the goals scored by each team as shown
-- Sort the result by mdate, matchid, team1 and team2
-- Use 'CASE WHEN'
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
FROM game LEFT JOIN goal ON goal.matchid = game.id
GROUP BY game.id
ORDER BY mdate, matchid, team1, team2

-- Part 2:
-- The database consists of three tables movie , actor and casting
-- 10. List the films together with the leading star for all 1962 films
SELECT movie.title, actor.name
FROM movie
  JOIN casting ON movieid=movie.id
  JOIN actor ON actorid=actor.id
WHERE yr=1962
  AND ord=1

-- 11. Which were the busiest years for 'Rock Hudson'.
-- Show the year and the number of movies he made each year for any year 
-- in which he made more than 2 movies
SELECT yr, COUNT(title)
FROM movie JOIN casting ON movie.id=movieid
  JOIN actor ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

-- 12. List the film title and the leading actor 
-- for all of the films 'Julie Andrews' played in
-- tip: Film title is not unique, go with movie id
SELECT title, name
FROM casting
  JOIN movie ON (movieid=movie.id)
  JOIN actor ON (actorid=actor.id AND ord=1)
WHERE movieid IN(
    SELECT movieid
FROM casting
  JOIN actor ON actorid=actor.id
WHERE name ='Julie Andrews')

-- OR:
SELECT title, name
FROM casting
  JOIN movie ON (movieid=movie.id)
  JOIN actor ON (actorid=actor.id AND ord=1)
WHERE movieid IN(
    SELECT movieid
FROM casting
WHERE actorid IN (SELECT actor.id
FROM actor
WHERE name ='Julie Andrews'))

-- 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles
SELECT name
FROM casting
  JOIN actor ON actorid=actor.id
WHERE ord=1
GROUP BY name
HAVING COUNT(*)>=15

-- 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title
SELECT title, COUNT(actorid)
FROM casting
  JOIN movie ON movieid=movie.id
  JOIN actor ON actorid=actor.id
WHERE yr=1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title

-- 15. List all the people who have worked with 'Art Garfunkel'
SELECT DISTINCT name
FROM actor
  JOIN casting ON actorid=actor.id
  JOIN movie ON movieid=movie.id
WHERE movieid IN(
                SELECT movieid
  FROM casting
    JOIN actor ON actorid=actor.id
  WHERE name='Art Garfunkel')
  AND name!='Art Garfunkel'
