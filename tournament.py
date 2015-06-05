#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2
import os

class DB():
    def __init__(self):
        # fetch the database user and password from set environment variables
        psqlUser = os.environ['UDACITY_TOURNAMENT_PSQL_USER']
        psqlPass = os.environ['UDACITY_TOURNAMENT_PSQL_PASS']

        self.con = self.connectDB()
        self.c = self.con.cursor()
        self.current_round = None
        self.tournament = None

    # #DATABASE AND TABLES#
    def connectDB(self):
        """Connect to the PostgreSQL database.  Returns a database connection."""
        return psycopg2.connect(database='tournament',\
                                user=psqlUser,\
                                password=psqlPass)

    def createTables(self):
        """Reads the sql file and creates the Tables accordingly to in.

        Args:
            conn: the current connection to the database. see connect()"""
        f = open('tournament.sql')
        shema = f.read()
        self.c.execute(shema)
        self.con.commit()

    # #TOURNAMENTS#
    def deleteTournaments(self):
        '''Removes all the tournaments from the database.'''
        self.c.execute("DELETE FROM tournaments;")
        self.con.commit()

    def addTournament(self,name):
        '''Adds a new Tournament to the Database and sets
        the DB.tournament to the created id'''
        self.tournament = self.c.execute("INSERT INTO tournament (name) \
                        VALUES (%s) RETURNING id",\
                        [name]).fetchone()[0]
        self.con.commit()
        return self.tournament

    # #PLAYERS#
    def deletePlayers(self):
        """Remove all the player records from the database."""
        self.c.execute("DELETE FROM players;")
        self.con.commit()

    def countPlayers(self):
        """Returns the number of players currently registered."""
        return self.c.execute("SELECT count(*) as num FROM players;").fetchall()

    def addPlayer(self,name):
        """Adds a player to the tournament database.
      
        The database assigns a unique serial id number for the player. 
        A Player added to the database does not include that the player
        is registered for a tournament.
        call registerPlayer(playerID,tournamentID) to do so.

        Args:
          name: the player's full name (need not be unique).
        """
        participantID = self.c.execute("INSERT INTO players (name) VALUES (%s) RETURNING id;",
                        [name]).fetchone([0])
        self.con.commit()
        return participantID

    def registerPlayer(self,tournamentID,participantID):
        '''Registeres a Player from the database to a tournament form the 
        database. 

        take care that before registering a player to a tournament both must be
        created in the databse first. 
        do so by calling:
        intID DB.addTournament(name)
        intID DB.addPlayer(name)
        '''
        self.c.execute("INSERT INTO registered (tournament,participant) VALUES (%s,%s)",
            [tournamentID,participantID])

    def playerStandings(self):
        """Returns a list of the players and their win records, sorted by wins.

        The first entry in the list should be the player in first place, or a player
        tied for first place if there is currently a tie.

        Returns:
          A list of tuples, each of which contains (id, name, wins, matches):
            id: the player's unique id (assigned by the database)
            name: the player's full name (as registered)
            wins: the number of matches the player has won
            draws: the number of matches resulted in a draw
            matches: the number of matches the player has played
        """
        return self.c.execute("SELECT * FROM players ORDER BY wins DESC;").fetchall()

    # #MATCHES#
    def deleteMatches(self):
        """Remove all the match records from the database."""
        self.c.execute("DELETE FROM matches;")
        self.c.commit()

    def swissPairings(self):
        """Returns a list of pairs of players for the next round of a match.
      
        Assuming that there are an even number of players registered, each player
        appears exactly once in the pairings.  Each player is paired with another
        player with an equal or nearly-equal win record, that is, a player adjacent
        to him or her in the standings.
      
        Returns:
          A list of tuples, each of which contains (id1, name1, id2, name2)
            id1: the first player's unique id
            name1: the first player's name
            id2: the second player's unique id
            name2: the second player's name
        """


    # #REPORTS#
    def reportMatch(self,p1,p2,score_p1,score_p2):
        """Records the outcome of a single match
        between two participants (player or team).

        Winner and Looser or Draw is calculated 
        for the one with the higher score.
        
        If equal Winner / Looser will be None
        Draw will be True

        Args:
            p1: the id of participant_1
            p2: the id of participant_2
            score_p1: the score of p1
            score_p2: the score of p2
        """

        winner,looser = None
        draw = False
        if score_p1 > score_p2:
            winner = p1
            looser = p2
        elif score_p1 < score_p2:
            winner = p2
            looser = p1
        else:
            draw = True

        update = [winner,looser,draw,p1_score,p2_score,self.current_round,p1,p2]

        self.c.execute("UPDATE matches SET \
                        winner=?,\
                        looser=?,\
                        draw=?,\
                        score_participant_1=?,\
                        score_participant_2=?\
                        WHERE \
                        round = ? AND participant_1=? AND participant_2=?",\
                        update)

        # because of using scores instead of just winner looser and the additional
        # posibility of a draw this needs to be completly rewritten - see above
        # def reportMatch(winner, loser,):
        #     self.c.execute("UPDATE matches SET winner=?,looser=? ")
     

if __name__ == "__main__":
    db = DB()
    db.createTables()
    print db.addTournament('test')