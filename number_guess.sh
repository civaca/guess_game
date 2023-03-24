#!/bin/bash
NUMBER=$( echo $(($RANDOM % 1000 +1 )))
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo Enter your username:
read USERNAME


USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
#if user is not foungd 
if [ -z $USER_ID ]
then 
echo Welcome, $USERNAME! It looks like this is your first time here.
INSERT_USERNAME=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

else 
GAMES_PLAYED=$($PSQL "SELECT COUNT(games_guesses) FROM games WHERE user_id='$USER_ID'")
MIN_PLAYED=$($PSQL "SELECT MIN(games_guesses) FROM games WHERE user_id='$USER_ID'")
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $MIN_PLAYED guesses."
fi #IF IT NOT FOUND

echo Guess the secret number between 1 and 1000:
read NUMBER_GUESSED

while [[ ! $NUMBER_GUESSED =~ ^[0-9]+$ ]]
do
 echo "That is not an integer, guess again:"
 read NUMBER_GUESSED
done

NUMBER_OF_GUESSES=1
 

while [ ! $NUMBER_GUESSED == $NUMBER ]
  do 

  if [[ $NUMBER_GUESSED -gt $NUMBER ]]
  then 
  echo "It's lower than that, guess again:"
  read NUMBER_GUESSED
  NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES+1))
  else 
  echo "It's higher than that, guess again:"
  read NUMBER_GUESSED
  NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES+1))
  fi
done

  if [[ $NUMBER_GUESSED == $NUMBER ]]
  then 
  INSERT_GUESSES=$($PSQL "INSERT INTO games(user_id,games_guesses) VALUES ($USER_ID,$NUMBER_OF_GUESSES)")
  echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!"
  fi



