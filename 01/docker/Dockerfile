FROM python:3.8-alpine
RUN pip install flask
RUN pip install gunicorn
COPY ./flaskapp/ /app
WORKDIR /app
CMD ["gunicorn","-w 4","wsgi:app"]
