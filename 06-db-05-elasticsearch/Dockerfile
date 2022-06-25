FROM elasticsearch:7.17.4

# container creator
MAINTAINER dpopov

#RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000
RUN chown -R 1000:1000 /var/lib

# copy the configuration file into the container
COPY elasticsearch.yml /usr/share/elasticsearch/config

# expose the default Elasticsearch port
EXPOSE 9200 9300
