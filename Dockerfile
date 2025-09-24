FROM python:3.12 AS builder
WORKDIR /app
RUN pip install django==5.2.6
COPY . .
RUN python manage.py collectstatic --noinput

FROM gcr.io/distroless/python3-debian12
WORKDIR /app
ENV PYTHONPATH=/usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /app .
EXPOSE 8000
ENTRYPOINT ["python3"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]