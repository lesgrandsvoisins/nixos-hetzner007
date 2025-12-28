#!/bin/sh
user=`whoami`
group="users"
DIR_CONFIG="/etc/homarr"
DIR_CACHE="/var/cache/homarr"
DIR_LIB="/var/lib/homarr"
DIRS="$DIR_CONFIG $DIR_CACHE $DIR_LIB $DIR_LIB/db $DIR_LIB/ssl"
for DIR in $DIRS 
do
  echo $DIR
  sudo mkdir -p $DIR
  sudo chown $user:$group $DIR
  sudo chmod 0775 $DIR
done
if [ ! -f "$DIR_CONFIG/homarr.env" ]
then
  cp $(dirname $0)/homarr.env $DIR_CONFIG/homarr.env
fi
sed -i "s/@LOG_LEVEL@/info/" $DIR_CONFIG/homarr.env
sed -i "s|@CRON_JOB_API_KEY@|"`openssl rand -base64 32`"|"  $DIR_CONFIG/homarr.env
sed -i "s|@SECRET_ENCRYPTION_KEY@|"`openssl rand -hex 32`"|"  $DIR_CONFIG/homarr.env
sed -i "s|@AUTH_SECRET@|"`openssl rand -hex 32`"|"  $DIR_CONFIG/homarr.env
sed -i "s/@DB_DRIVER@/better-sqlite3/"  $DIR_CONFIG/homarr.env
sed -i "s|@ENABLE_KUBERNETES@|false|"  $DIR_CONFIG/homarr.env
sed -i "s|@DB_URL@|$DIR_LIB/homarr.sqlite3|"  $DIR_CONFIG/homarr.env
if [ ! -f "$DIR_LIB/db/homarr.sqlite3" ]
then
  touch $DIR_LIB/db/homarr.sqlite3
fi
sed -i "s|@LOCAL_CERTIFICATE_PATH@|$DIR_LIB/ssl/|"  $DIR_CONFIG/homarr.env
sed -i "s|@UNSAFE_ENABLE_MOCK_INTEGRATION@|true|"  $DIR_CONFIG/homarr.env
