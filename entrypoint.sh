#!/bin/bash

# create the static_collected directory with the correct permissions

function migrate_django_db () {
    echo -e "\n :: Migrating DB  \n";
    python3 manage.py migrate

}

function collectstatic_django() {
    echo -e "\n :: Collecting static files \n";
    python3 manage.py collectstatic --no-input
}



function start_django(){
    echo -e "\n :: Starting Django \n";
    exec gunicorn --bind 0.0.0.0:8000 web_project.wsgi
}

function wait_for_db () {
    echo -e "\n :: Waiting For DB to Ready \n";
    for i in {1..15}
    do
        echo -e "\n Waiting $i \n";
        sleep 1;
    done
}

function update_db_from_sever(){
  echo -e "\n :: Exporting Data from Server \n";
  mysqldump -h 0.0.0.0 --column-statistics=0  -u root -pshort@xy123 data_pipeline > backup_name.sql

  echo -e "\n :: Import Data to Database \n";
  mysql -h 0.0.0.0 -P 3307 -u root -pshort@xy123 data_pipeline < backup_name.sql
}

wait_for_db

migrate_django_db

# update_db_from_sever

collectstatic_django

start_django
