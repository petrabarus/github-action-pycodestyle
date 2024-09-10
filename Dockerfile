# MIT License
#
# Copyright (c) 2024 Petra Barus
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
