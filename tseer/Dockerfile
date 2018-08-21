FROM centos

MAINTAINER DerekYuan <derekyuan@tencent.com>

# 安装常用软件
RUN yum install -y gcc gcc-c++ glibc-devel git openssh-server cmake flex bison java-1.8.0-openjdk java-1.8.0-openjdk-devel \
        wget curl unzip openssl-devel && yum clean all
ENV JAVA_HOME "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64"
ENV CLASSPATH "$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar"

# 安装TSeer
RUN mkdir /root/src/ && git clone https://github.com/Tencent/TSeer.git /root/src/tseer && cd /root/src/tseer/build && python tseer_deploy.py

# 安装maven
RUN cd /root/src/ && wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz &&\
    tar xf /root/src/apache-maven-3.5.3-bin.tar.gz -C /usr/local/ && rm -f /root/src/apache-maven-3.5.3-bin.tar.gz
ENV MAVEN_HOME "/usr/local/apache-maven-3.5.3/"
ENV PATH "$PATH:/usr/local/apache-maven-3.5.3/bin"

# 安装resin
RUN cd /root/src/ && wget http://caucho.com/download/resin-4.0.55.tar.gz && tar xf /root/src/resin-4.0.55.tar.gz -C /root/src && \
    cd /root/src/resin-4.0.55 && ./configure --prefix=/usr/local/resin && make && make install && rm -rf /root/src/resin*

# 安装web管理系统
RUN cd /root/src/tseer/web && sed -i 's/10.229.136.145/172.17.0.2/g' src/main/resources/seer.conf && \
        sed -i 's/9203/9903/g' src/main/resources/seer.conf &&  sed -i 's/10.229.136.145:9204/172.17.0.2:9904/g' src/main/resources/system.properties && \
        mvn clean && mvn install && cp target/seer-1.0.0-SNAPSHOT.war /usr/local/resin/webapps/ && \
        sed -i 's/ROOT/seer-1.0.0-SNAPSHOT/g' /usr/local/resin/conf/resin.xml

COPY tseer_start.sh /sbin/

EXPOSE 8080

EXPOSE 22

