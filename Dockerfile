FROM kalilinux/kali-linux-docker

MAINTAINER delta24

RUN apt-get update && apt-get upgrade -y

#Kali SSL lib-fix
ENV PYCURL_SSL_LIBRARY openssl

COPY packages.sh /
RUN ["sh", "packages.sh"]

COPY owtf.pip /
COPY optional_tools.sh /
RUN ["pip", "install", "--upgrade", "pip"]
RUN ["pip", "install", "--upgrade", "-r", "owtf.pip"]

#download latest OWTF
RUN git clone -b develop https://github.com/owtf/owtf.git
RUN mkdir owtf/tools/restricted

###################
COPY modified/install.py owtf/install/install.py
RUN ["python", "owtf/install/install.py"]
###################
COPY modified/db_setup.sh owtf/scripts/db_setup.sh
COPY modified/owtfdbinstall.sh owtf/scripts/
RUN ["/bin/bash", "owtf/scripts/owtfdbinstall.sh"]
###################
COPY modified/dbmodify.py owtf/scripts/
RUN ["python", "owtf/scripts/dbmodify.py"]
###################
COPY modified/interface_server.py owtf/framework/interface/
RUN ["mv", "-f", "owtf/framework/interface/interface_server.py", "owtf/framework/interface/server.py"]

#optional tools for OWTF
#RUN ["/bin/sh", "optional_tools.sh"]
COPY optional_tools.sh /usr/local/bin

#cert-fix
RUN mkdir /.owtf ; cp -r /root/.owtf/* /.owtf/

EXPOSE 8009 8008

#set entrypoint
COPY owtf_entry.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/owtf_entry.sh"]

# cleanup
RUN rm packages.sh owtf.pip
#copy executable
COPY owtf.py /usr/local/bin/
#CMD ["python", "owtf/owtf.py"]
