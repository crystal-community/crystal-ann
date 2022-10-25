# syntax=docker/dockerfile:1
FROM crystallang/crystal:0.24.1 as builder

RUN apt-get update

WORKDIR /app
COPY . /app
RUN shards --production

# RUN mkdir bin && crystal build --release src/crystal-ann.cr -o bin/crystal_ann
RUN mkdir bin && crystal build src/crystal-ann.cr -o bin/crystal_ann
RUN chmod +x bin/crystal_ann

CMD ["bin/crystal_ann"]
