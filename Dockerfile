FROM python:3.12-slim

# Ensure Python output is not buffered (helpful for Docker logs)
ENV PYTHONUNBUFFERED=1

# Update & install build deps in a single layer, keep image small
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
#        vim \
        gcc \
        g++ \
        python3-dev \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        locales \
        locales-all \
        unixodbc-dev \
        unixodbc \
    && rm -rf /var/lib/apt/lists/*

# Ensure pip/setuptools are recent
RUN pip install --upgrade pip setuptools

COPY ./sources /opt/sources
RUN pip install -r /opt/sources/requirements.txt

# pyodbc needs unixodbc dev headers (installed above)
RUN pip install pyodbc || true

RUN rm -rf /opt/sources/logs || true
RUN mkdir -p /opt/sources/logs

WORKDIR /opt/sources
CMD ["python3", "nyx_lambda.py"]