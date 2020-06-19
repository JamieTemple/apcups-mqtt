# Note - this dockerfile is for "old" Raspberry Pis (2 or Zero)

FROM arm32v5/python:3

COPY ./apcups-mqtt.py /app/apcups-mqtt.py
COPY ./requirements.txt /app/requirements.txt

ADD start.sh /
RUN chmod +x /start.sh

WORKDIR /app

RUN apt-get update && \
    apt-get install -y apcupsd && \
    apt-get -y upgrade

RUN echo "ISCONFIGURED=yes" > /etc/default/apcupsd

RUN service apcupsd restart

RUN pip install -r requirements.txt

CMD ["/start.sh"]
