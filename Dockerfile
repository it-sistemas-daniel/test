FROM node:18.19.1-alpine3.18 AS deps
WORKDIR /app
COPY package.json ./
RUN npm install --frozen-lockfile

FROM node:18.19.1-alpine3.18 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:18.19.1-alpine3.18 AS prod
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY . .

ENV PORT=8080
ENV MAILER_HOST=mail.hortomallas.com
ENV MAILER_PORT=465
ENV MAILER_SERVICE=hortomallas
ENV MAILER_EMAIL=multimedia@hortomallas.com
ENV MAILER_PASSWORD="]4KE~11g111m"
ENV MAILER_NAME_EMAIL=HORTOMALLAS®

EXPOSE 8080
CMD [ "npm", "run", "start:prod" ]