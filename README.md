# Emphie - Docker Image for CI

## Image

Image based on docker:20.10

## Software

- AWS CLI
- bash
- rsync
- jq
- git

## Build & Publish

```
docker build --platform linux/amd64 -t emphie/ci:latest .
docker push emphie/ci:latest
```
