/etc/init.d/mysql start
cd /usr/pleak/pleak-backend
mysql -u root < src/main/resources/db/setup.sql
mysql -u root -D pleak < /usr/pleak/examples/dump.sql
# mvn flyway:migrate
# mysql -u root --password= < src/main/resources/db/dev.sql
