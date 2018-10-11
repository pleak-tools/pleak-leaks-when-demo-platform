FROM debian:jessie

## =================================================== 
##     MySQL
## =================================================== 
RUN groupadd -r mysql && useradd -r -g mysql mysql

# add gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget gnupg2 dirmngr && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates wget

RUN mkdir /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y --no-install-recommends \
# for MYSQL_RANDOM_ROOT_PASSWORD
		pwgen \
# for mysql_ssl_rsa_setup
		openssl \
# FATAL ERROR: please install the following Perl modules before executing /usr/local/mysql/scripts/mysql_install_db:
# File::Basename
# File::Copy
# Sys::Hostname
# Data::Dumper
		perl \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
	key='A4A9406876FCBD3C456770C88C718D3B5072E1F5'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
	rm -r "$GNUPGHOME"; \
	apt-key list > /dev/null

ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.23-1debian8

RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

# the "/var/lib/mysql" stuff here is because the mysql-server postinst doesn't have an explicit way to disable the mysql_install_db codepath besides having a database already "configured" (ie, stuff in /var/lib/mysql/mysql)
# also, we set debconf keys to make APT a little quieter
RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}" && rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	&& chmod 777 /var/run/mysqld

# comment out a few problematic configuration values
# don't reverse lookup hostnames, they are usually another container
RUN sed -Ei 's/^(log)/#&/' /etc/mysql/mysql.conf.d/mysqld.cnf \
    && echo '[mysqld]\nskip-host-cache' > /etc/mysql/conf.d/docker.cnf

VOLUME /var/lib/mysql

RUN apt-get update
RUN apt-get install -y wget curl vim
RUN apt-get update && apt-get install -y git

RUN apt-get update
RUN apt-get install -y maven
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs build-essential
RUN wget -qO- https://get.haskellstack.org/ | sh

RUN > /etc/apt/sources.list
RUN echo 'deb http://ftp.ee.debian.org/debian/ jessie main' >> /etc/apt/sources.list
RUN echo 'deb http://ftp.ee.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list
RUN echo 'deb http://ftp.ee.debian.org/debian/ jessie-backports main' >> /etc/apt/sources.list
RUN echo 'deb http://security.debian.org/ jessie/updates main' >> /etc/apt/sources.list
RUN echo 'deb [arch=amd64] https://download.docker.com/linux/debian jessie stable' >> /etc/apt/sources.list

RUN apt-get update

WORKDIR /usr/pleak
RUN git clone https://github.com/Z3Prover/z3.git
WORKDIR /usr/pleak/z3
RUN python scripts/mk_make.py
WORKDIR /usr/pleak/z3/build
RUN make
RUN make install

ENV PATH "$PATH:/home/pleak/.local/bin/z3/bin"

WORKDIR /usr/pleak
RUN git clone --recurse-submodules https://github.com/pleak-tools/pleak-sql-analysis.git
WORKDIR /usr/pleak/pleak-sql-analysis
RUN git submodule init
RUN git submodule update


RUN echo 'deb http://ftp.debian.org/debian/ jessie-backports main' | tee /etc/apt/sources.list.d/backports.list sudo
RUN apt-get update && apt-get -y -t jessie-backports install ghc cabal-install sudo
RUN apt-get install -y netbase


RUN stack setup
RUN stack build
RUN ln -s .stack-work/install/x86_64-linux/lts-7.19/8.0.1/bin/sqla .

RUN echo 'deb http://ftp.debian.org/debian/ jessie-backports main' | tee /etc/apt/sources.list.d/backports.list sudo
RUN apt-get update && apt-get -y -t jessie-backports install ghc cabal-install sudo
RUN cabal update && echo export PATH='$HOME/.cabal/bin:$PATH' >> $HOME/.bashrc

WORKDIR /usr/pleak/pleak-sql-analysis/banach
RUN cabal sandbox init
RUN cabal install mtl-2.2.2
RUN cabal install happy
RUN apt-get install -y libpq-dev
RUN sudo cabal install
RUN cabal configure
RUN cabal build

COPY pleak-pe-bpmn-editor /usr/pleak/pleak-pe-bpmn-editor
WORKDIR /usr/pleak/pleak-pe-bpmn-editor
RUN npm install
RUN npm run build

COPY pleak-backend /usr/pleak/pleak-backend
WORKDIR /usr/pleak/pleak-backend
RUN mvn dependency:go-offline

COPY pleak-sql-editor /usr/pleak/pleak-sql-editor
WORKDIR /usr/pleak/pleak-sql-editor
RUN npm install
RUN npm run build

COPY pleak-frontend /usr/pleak/pleak-frontend
WORKDIR /usr/pleak/pleak-frontend
RUN npm install
RUN npm run build

COPY pleak-sql-derivative-sensitivity-editor /usr/pleak/pleak-sql-derivative-sensitivity-editor
WORKDIR /usr/pleak/pleak-sql-derivative-sensitivity-editor
RUN npm install
RUN npm run build

RUN echo "deb http://http.debian.net/debian jessie-backports main" | \
      sudo tee --append /etc/apt/sources.list.d/jessie-backports.list > /dev/null

RUN sudo apt-get update
RUN sudo apt-get -y install -t jessie-backports openjdk-8-jdk
RUN sudo update-java-alternatives -s java-1.8.0-openjdk-amd64

COPY scripts /usr/pleak/scripts
COPY examples /usr/pleak/examples
COPY examples/10 /usr/pleak/pleak-backend/src/main/webapp/files
COPY examples/11 /usr/pleak/pleak-backend/src/main/webapp/files
COPY examples/32 /usr/pleak/pleak-backend/src/main/webapp/files
COPY examples/34 /usr/pleak/pleak-backend/src/main/webapp/files
RUN chmod 777 /usr/pleak/scripts/*.sh

CMD sh /usr/pleak/scripts/db-setup.sh; sh /usr/pleak/scripts/launch.sh
