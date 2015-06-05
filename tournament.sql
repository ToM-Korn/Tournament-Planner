-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- LEGEND 
-- - TOURNAMENT
-- 		a tournament i think is clear
-- 		participants (players or teams) can attend tournaments 
-- - MATCHES
-- 		a tournament in swiss style has rounds 
-- 		with in these rounds are matches between two participants
-- 		this is reflected by matches 
-- 		a round is a pairing of participants within a tournament and is 
-- 		reflected as matches
-- 		a match has a score that is used to rank participants in an appropiate
-- 		scale
-- 		won 3 points, lost 0 points, draw 1 point (for each participant)
-- - GAMES 
-- 		each match has one game 
-- 		the score in the game can be anything that matches the game
-- 		example: 
-- 			football 6:3 goals, 
-- 			chess 24:12 figures drawn from the oponent, 
-- 			scissors-stone-paper 2:1 two wins one lost
-- 			...	


DROP TABLE IF EXISTS tournaments CASCADE;

CREATE TABLE tournaments (
	id SERIAL PRIMARY KEY,
	name TEXT,
	rounds_played INTEGER DEFAULT 0,
	rounds_to_play INTEGER DEFAULT 0
);

DROP TABLE IF EXISTS participants CASCADE;

CREATE TABLE participants (
	id SERIAL PRIMARY KEY,
	name text
);

DROP TABLE IF EXISTS registered CASCADE;

CREATE TABLE registered(
	tournament INTEGER REFERENCES tournaments ON DELETE CASCADE,
	participant INTEGER REFERENCES participants ON DELETE CASCADE
);

DROP TABLE IF EXISTS matches CASCADE;

CREATE TABLE matches (
	id SERIAL PRIMARY KEY,
	tournament INTEGER REFERENCES tournaments ON DELETE CASCADE,
	round INTEGER NOT NULL,
	participant_1 INTEGER REFERENCES participants ON DELETE SET NULL,
	participant_2 INTEGER REFERENCES participants ON DELETE SET NULL,
	played BOOLEAN DEFAULT FALSE
);

DROP TABLE IF EXISTS games CASCADE;

CREATE TABLE games(
	id SERIAL PRIMARY KEY,
	match INTEGER REFERENCES matches ON DELETE CASCADE
);

DROP TABLE IF EXISTS base_scores CASCADE;

-- base_scores is the mother of matches_scores and games_scores
-- it saves primerly typing but we could also collect all
-- matches and games a participant attended by calling base_scores
CREATE TABLE base_scores(
	participant INTEGER REFERENCES participants ON DELETE SET NULL,
	score INTEGER DEFAULT 0,
	-- outcome will be one of 1 for WIN, -1 for LOST, 0 for DRAW
	-- if there are multiple games for each match
	-- this makes it easy to calculate a winner
	-- we just need to sum up the outcome 
	-- eg: 3 games played - outcome is -1, 1, 0 
	-- if the total is bigger than 0 it is a win
	-- if less than 0 it is a los 
	-- if equal 0 it is a draw
	-- 
	-- in case of tournament we can calculate the winner with it
	-- based on wins
	--
	-- the more appropiate variant is to take the scores, or?
	outcome INTEGER
);

DROP TABLE IF EXISTS matches_scores;

CREATE TABLE matches_scores(
	match INTEGER REFERENCES matches ON DELETE CASCADE
) INHERITS (base_scores);

DROP TABLE IF EXISTS games_scores;

CREATE TABLE games_scores(
	game INTEGER REFERENCES games ON DELETE CASCADE
) INHERITS (base_scores);

-- we create a view that takes all matches
-- this will be the base to fetch the matches and games to play
CREATE VIEW matches_to_play
	AS SELECT * FROM matches WHERE played = FALSE;

-- and the opposite - can be used for the next view - participant_scores
CREATE VIEW matches_played
	AS SELECT * FROM matches WHERE played = TRUE;

-- PARTICIPANT SCORES
-- this is a big one where we gather together a lot of info
-- this will help us later to rank the participants
--
-- in the participant_scores we collect all the match scores and 
-- game points as well as matches played and collect them 
-- into one view - as well the match wins and game wins 
-- percentage is calculated on the fly
--
-- as basis we take matches_played view
-- the whole view is grouped by participants and tournaments 
-- that makes it later easy to get scores from users by 
-- the condition of tournament id

CREATE VIEW participant_scores
	AS SELECT
		tournament, 
		participant,
		matches_score,
		matches_played,
		matches_won,
		matches_outcome,
		((matches_won*100/matches_played)) AS match_win_percentage 
	FROM 
		(SELECT 
			participant, 
			tournament, 
			SUM(score) AS matches_score, 
			COUNT(match) AS matches_played,
			SUM(outcome) AS matches_outcome
		FROM (matches_scores RIGHT JOIN matches_played ON match = id) AS a
		GROUP BY participant, tournament
		ORDER BY matches_score DESC)
	AS ag1
	LEFT JOIN
		(SELECT
			SUM(s.outcome) AS matches_won,
			m.tournament,
			p.id AS participant  
		FROM matches_scores AS s, matches_played AS m, participants as p
		WHERE s.match = m.id AND 
			(p.id = m.participant_1 OR p.id = m.participant_2) AND
			s.outcome = 1
		GROUP BY p.id,m.tournament)
	AS ag2 
	USING (tournament,participant)
	ORDER BY tournament ASC, matches_score DESC;
	-- TODO 
		-- get games in this table as well - would make it possible 
		-- to see how much goals where shot by a team during 
		-- a turnament in one view
