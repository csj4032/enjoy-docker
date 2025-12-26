FROM apache/airflow:3.1.5
ADD requirements.txt .
RUN pip install --upgrade pip
RUN pip install apache-airflow==${AIRFLOW_VERSION} -r requirements.txt
USER airflow