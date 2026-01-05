#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat 'games.csv' | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $WINNER != 'winner' ]]
then
TEAM_ID=$($PSQL "select name from teams where name = '$WINNER'")
if [[ -z $TEAM_ID ]]
then 
ADD_TEAM_RESULT=$($PSQL "insert into teams (name) values ('$WINNER')")
fi

TEAM_ID=$($PSQL "select name from teams where name = '$OPPONENT'")
if [[ -z $TEAM_ID ]]
then 
ADD_TEAM_RESULT=$($PSQL "insert into teams (name) values ('$OPPONENT')")
fi

WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
INSERT_INTO_GAMES=$($PSQL "insert into games (year,round,winner_goals,opponent_goals,winner_id,opponent_id) values ($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID) ")
fi
done