#!/bin/bash

NAME="PROJECTNAME"
DJANGODIR=/webapps/PROJECTDIR/PROJECTNAME
SOCKFILE=/webapps/PROJECTDIR/run/gunicorn.sock
USER=UNIXUSERNAME
GROUP=webapps
NUM_WORKERS=1
TIMEOUT=60
#DJANGO_SETTINGS_MODULE=PROJECTNAME.settings
#DJANGO_WSGI_MODULE=PROJECTNAME
DJANGO_SETTINGS_MODULE=portal.settings
DJANGO_WSGI_MODULE=portal

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
source ../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ../bin/gunicorn ${DJANGO_WSGI_MODULE}.wsgi:application \
 --pythonpath . \
 --name $NAME \
 --workers $NUM_WORKERS \
 --user=$USER --group=$GROUP \
 --bind=unix:$SOCKFILE \
#  --log-level=debug \
 --log-file=-
