/etc/init.d/mysql start
cd /usr/pleak/pleak-frontend; node server.js &
cd /usr/pleak/pleak-backend; nohup mvn tomcat:run
