FROM apache/airflow:2.10.4-python3.10

USER root

RUN apt update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get install -y ant && \
    apt-get clean;

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64/
RUN export JAVA_HOME

RUN mkdir -p /opt/airflow/spark/jars

RUN curl -o /opt/airflow/spark/jars/postgresql-42.2.18.jar https://jdbc.postgresql.org/download/postgresql-42.2.18.jar && \
    curl -o /opt/airflow/spark/jars/mysql-connector-java-8.3.0.jar https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar

USER airflow
COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt
ENV PYTHONPATH="${PYTHONPATH}:/opt/airflow/scripts" 

# Entrypoint
CMD ["scheduler"]