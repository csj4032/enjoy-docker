from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator

# DAG에 사용할 기본 설정 정의
default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Python 함수 정의
def start():
    print("DAG 시작!")

def process():
    print("데이터 처리 중...")

def end():
    print("DAG 완료!")

# DAG 정의
with DAG(
        dag_id='simple_dag',
        default_args=default_args,
        description='간단한 예제 DAG',
        schedule_interval=timedelta(days=1),  # 매일 실행
        start_date=datetime(2024, 10, 28),
        catchup=False,
) as dag:

    # 태스크 정의
    start_task = PythonOperator(
        task_id='start_task',
        python_callable=start
    )

    process_task = PythonOperator(
        task_id='process_task',
        python_callable=process
    )

    end_task = PythonOperator(
        task_id='end_task',
        python_callable=end
    )


    # 태스크 의존성 설정
    start_task >> process_task >> end_task