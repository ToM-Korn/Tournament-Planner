INSERT INTO tournaments (name) VALUES ('test tournament');
INSERT INTO participants (name) VALUES ('tom');
INSERT INTO participants (name) VALUES ('paul');
INSERT INTO participants (name) VALUES ('frank');
INSERT INTO participants (name) VALUES ('judith');
INSERT INTO participants (name) VALUES ('sarah');
INSERT INTO participants (name) VALUES ('lucy');
INSERT INTO matches VALUES (DEFAULT,1,1,1,2,True);
INSERT INTO matches VALUES (DEFAULT,1,1,3,4,FALSE);
INSERT INTO matches VALUES (DEFAULT,1,1,5,6,TRUE);
INSERT INTO matches_scores VALUES (1,3,1,1);
INSERT INTO matches_scores VALUES (2,0,-1,1);
INSERT INTO matches_scores VALUES (3,1,0,2);
INSERT INTO matches_scores VALUES (4,1,0,2);
INSERT INTO matches_scores VALUES (5,0,-1,3);
INSERT INTO matches_scores VALUES (6,3,1,3);
INSERT INTO matches VALUES (DEFAULT,1,2,1,2,True);
INSERT INTO matches VALUES (DEFAULT,1,2,3,4,FALSE);
INSERT INTO matches VALUES (DEFAULT,1,2,5,6,TRUE);
INSERT INTO matches_scores VALUES (1,2,1,4);
INSERT INTO matches_scores VALUES (2,1,-1,4);
INSERT INTO matches_scores VALUES (3,3,1,5);
INSERT INTO matches_scores VALUES (4,0,-1,5);
INSERT INTO matches_scores VALUES (5,1,-1,6);
INSERT INTO matches_scores VALUES (6,2,1,6);
INSERT INTO matches VALUES (DEFAULT,1,3,1,2,True);
INSERT INTO matches VALUES (DEFAULT,1,3,3,4,FALSE);
INSERT INTO matches VALUES (DEFAULT,1,3,5,6,TRUE);
INSERT INTO matches_scores VALUES (1,2,0,7);
INSERT INTO matches_scores VALUES (2,2,0,7);
INSERT INTO matches_scores VALUES (3,3,1,8);
INSERT INTO matches_scores VALUES (4,0,-1,8);
INSERT INTO matches_scores VALUES (5,0,0,9);
INSERT INTO matches_scores VALUES (6,0,0,9);
INSERT INTO tournaments (name) VALUES ('test tournament2');
INSERT INTO matches VALUES (DEFAULT,2,1,1,2,True);
INSERT INTO matches VALUES (DEFAULT,2,1,3,4,FALSE);
INSERT INTO matches VALUES (DEFAULT,2,1,5,6,TRUE);
INSERT INTO matches_scores VALUES (1,2,1,10);
INSERT INTO matches_scores VALUES (2,1,-1,10);
INSERT INTO matches_scores VALUES (3,3,1,11);
INSERT INTO matches_scores VALUES (4,0,-1,11);
INSERT INTO matches_scores VALUES (5,1,-1,12);
INSERT INTO matches_scores VALUES (6,2,1,12);
INSERT INTO matches VALUES (DEFAULT,2,2,1,2,True);
INSERT INTO matches VALUES (DEFAULT,2,2,3,4,FALSE);
INSERT INTO matches VALUES (DEFAULT,2,2,5,6,TRUE);
INSERT INTO matches_scores VALUES (1,2,0,13);
INSERT INTO matches_scores VALUES (2,2,0,13);
INSERT INTO matches_scores VALUES (3,3,1,14);
INSERT INTO matches_scores VALUES (4,0,-1,14);
INSERT INTO matches_scores VALUES (5,0,0,15);
INSERT INTO matches_scores VALUES (6,0,0,15);