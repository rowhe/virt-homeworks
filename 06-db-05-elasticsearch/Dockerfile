FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN  apt update && \
#    apt-get install -y --no-install-recommends software-properties-common && add-apt-repository -y ppa:webupd8team/java && \
#    apt-get update && \
#    (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections) && \
#   
#    apt-get install --no-install-recommends -y oracle-java8-installer && \
#    rm -rf /var/cache/oracle-jdk8-installer && \
#    apt-get install --no-install-recommends -y openjdk-8-jdk && \
#    rm -rf /var/cache/openjdk-8-jdk && \
#    echo "networkaddress.cache.ttl=60" >> /usr/lib/jvm/java-8-oracle/jre/lib/security/java.security && \
    apt install --no-install-recommends -y gnupg && \
    apt install --no-install-recommends -y  openjdk-8-jdk && \
    apt install --no-install-recommends -y curl && \
    (curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic.gpg) && \
    (echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list) && \
    apt update && \
    apt install --no-install-recommends -y elasticsearch && \
    rm -rf /var/cache/* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

#ENV JAVA_HOME /usr/lib/jvm/openjdk-8-jdk

#RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

#RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 && \
#    add-apt-repository -y "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" --keyserver https://pgp.mit.edu/ && \
#    apt-get update && \
#    apt-get install -y --no-install-recommends elasticsearch


WORKDIR /usr/share/elasticsearch
COPY elasticsearch.yml /etc/elasticsearch/
#COPY logging.yml /usr/share/elasticsearch/config/

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch /usr/share/elasticsearch; \
    done


USER elasticsearch

ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200
