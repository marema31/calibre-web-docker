#!/bin/bash

# get the current active timezone.
TZ=$(date | awk -F' ' '{print $5}')

# check if the timezone should be changed
if [ -n "$CONTAINER_TIMEZONE" ] && [ "$CONTAINER_TIMEZONE" != "$TZ" ]; then
    ln -sf "/usr/share/zoneinfo/$CONTAINER_TIMEZONE" /etc/localtime && \
    echo "$CONTAINER_TIMEZONE" > /etc/timezone && date
    echo "Setting container timezone to: $CONTAINER_TIMEZONE"
fi
echo "Creating calibre user"
if ! grep -Eq ":$PGROUP:" /etc/group
then
  groupadd -g "$PGROUP" calibre
fi
useradd -M -N -u "$PUSER" -g "$PGROUP" calibre

echo "Changing application owner"
chown -R "$PUSER:$PGROUP" /calibre-web
if ! gosu calibre test -w /calibre-web
then
  echo "Error: Was not able to write in application folder"
  exit 1
fi

if [[ ! -r /config/app.db ]]
then
  echo "Initialize application configuration"
  cp /calibre-web/dockerinit/app.db /config/app.db
fi
if [[ ! -r /config/gdrive.db ]]
then
  echo "Initialize gdrive configuration"
  cp /calibre-web/dockerinit/gdrive.db /config/gdrive.db
fi
echo "Changing configuration owner"
chown -R "$PUSER:$PGROUP" /config
if ! gosu calibre test -w /config/app.db -a -w /config/gdrive.db
then
  echo "Error: Was not able to write config databases"
  exit 1
fi

if [[ ! -r /books/metadata.db ]]
then
  echo "Initialize Library"
  cp /calibre-web/dockerinit/metadata.db /books/metadata.db
  chown "$PUSER:$PGROUP" /books/metadata.db
fi
if [[ ! -r /books/metadata_db_prefs_backup.json ]]
then
  echo "Initialize Library configuration"
  cp /calibre-web/dockerinit/metadata_db_prefs_backup.json /books/metadata_db_prefs_backup.json
  chown "$PUSER:$PGROUP" /books/metadata_db_prefs_backup.json
fi

if ! gosu calibre test -w /books/metadata.db -a -w /books/metadata_db_prefs_backup.json
then
  echo "Error: Was not able to write application databases"
  exit 1
fi

echo "Starting Calibre Web"
gosu "$PUSER:$PGROUP" bash -c "python /calibre-web/cps.py -p /config/app.db -g /config/gdrive.db"
