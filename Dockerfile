# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.10-slim-buster

RUN apt-get update \
        && apt-get install -y --no-install-recommends lsb-release gnupg \
        default-libmysqlclient-dev wget build-essential
RUN apt-get update \
        && apt-get install -y default-mysql-client python3-pip git
EXPOSE 8000

RUN apt-get update \
        && apt-get install -y python3-pip git
# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

WORKDIR /app
COPY . /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
# RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser
RUN chmod 744 /app/entrypoint.sh
# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
ENTRYPOINT ["/bin/bash","/app/entrypoint.sh"]
