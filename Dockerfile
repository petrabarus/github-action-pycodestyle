FROM python:3.12-slim

LABEL "maintainer"="Petra Barus <petra.barus@gmail.com>"
LABEL "com.github.actions.name"="Python Style Checker"
LABEL "com.github.actions.description"="Run PyCodeStyle on your Python."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="6f42c1"

RUN apt-get update && \
    apt-get install -y \
        curl \
        jq \
        git

RUN pip install --upgrade pip
RUN pip install pycodestyle
COPY run.sh /
RUN chmod +x /run.sh

# List all files in the github workspace including hidden files
RUN ls -la $GITHUB_WORKSPACE

# set the working directory to the github workspace
WORKDIR $GITHUB_WORKSPACE

ENTRYPOINT ["/run.sh"]
