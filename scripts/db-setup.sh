/etc/init.d/mysql start
cd /usr/pleak/pleak-backend
mysql -u root --password= < src/main/resources/db/setup.sql
mvn flyway:migrate
mysql -u root --password= < src/main/resources/db/dev.sql
