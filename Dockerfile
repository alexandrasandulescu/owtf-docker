FROM kalilinux/kali-linux-docker

MAINTAINER @delta24 viyat001@gmail.com, @alexandrasandulescu alecsandra.sandulescu@gmail.com

RUN apt-get update && apt-get upgrade -y

WORKDIR /home/

# install required packages from Kali repos
COPY packages.sh /tmp/
RUN /bin/bash /tmp/packages.sh

# upgrade pip and install required python packages
COPY owtf.pip /tmp/
RUN pip install --upgrade pip
RUN pip install --upgrade -r /tmp/owtf.pip

#Kali SSL lib-fix
ENV PYCURL_SSL_LIBRARY openssl

#download latest OWTF
RUN git clone -b develop https://github.com/owtf/owtf.git
RUN mkdir owtf/tools/restricted

# core installation
RUN python owtf/install/install.py --no-user-input --core-only

# DB installation and setup
COPY postgres_entry.sh /usr/bin/
RUN chmod +x /usr/bin/postgres_entry.sh
ENV POSTGRES_ENTRY /usr/bin/postgres_entry.sh

# expose ports
EXPOSE 8010 8009 8008

# cleanup
RUN rm /tmp/packages.sh /tmp/owtf.pip

COPY optional_tools.sh /usr/bin/
RUN chmod +x /usr/bin/optional_tools.sh
ENV OWTF_OPTIONAL_TOOLS /usr/bin/optional_tools.sh

#setup postgres
USER postgres
ENV PG_MAJOR 9.1
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# setting user to root
ENV USER root
USER root

#set entrypoint
COPY owtf_entry.sh /usr/bin/
RUN chmod +x /usr/bin/owtf_entry.sh

ENTRYPOINT ["/usr/bin/owtf_entry.sh"]
