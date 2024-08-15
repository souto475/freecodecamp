#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    QUERY_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
  else
    QUERY_RESULT=$($PSQL "SELECT * FROM elements WHERE (name='$1' OR symbol='$1')")
  fi

  if [[ -z $QUERY_RESULT ]]
  then
    echo I could not find that element in the database.
  else
    echo $QUERY_RESULT | sed "s/|/ /g" | while read atomic_number symbol name
    do
      PROPERTIES_QUERY=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties LEFT JOIN types USING (type_id) WHERE atomic_number = $atomic_number")
      echo $PROPERTIES_QUERY | sed "s/|/ /g" | while read type mass melting_point boiling_point 
      do
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
      done
    done
  fi
fi
