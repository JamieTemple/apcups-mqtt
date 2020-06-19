FROM arm32v5/python:3

COPY ./apcups-mqtt.py /app/apcups-mqtt.py
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

CMD python3 apcups-mqtt.py