FROM node:18-alpine as builder

WORKDIR /usr/app

ARG NG_APP_VERSION=0.0.0
ENV NG_APP_VERSION=$NG_APP_VERSION

COPY ./package*.json ./
RUN npm install

COPY . .

RUN npm run-script build:production


FROM nginx:stable-alpine-slim

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/app/dist /usr/share/nginx/html
