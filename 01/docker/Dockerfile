FROM python:3.8-alpine as base

FROM base as builder
RUN mkdir /install
WORKDIR /install
RUN pip install --prefix=/install flask
RUN pip install --prefix=/install gunicorn

FROM base
COPY --from=builder /install /usr/local
COPY ./flaskapp/ /app
WORKDIR /app
CMD ["gunicorn","-w 4","-b 0.0.0.0","wsgi:app"]
