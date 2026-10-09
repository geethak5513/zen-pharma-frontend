FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY public ./public
COPY src ./src
COPY .env.production ./
RUN npm run build

FROM nginx:stable-alpine
RUN addgroup -g 1000 pharma \
    && adduser -D -u 1000 -G pharma pharma
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
USER 1000:1000
EXPOSE 8080
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]