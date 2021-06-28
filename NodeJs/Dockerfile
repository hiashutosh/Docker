# build environment for ReactJS project
FROM node:13.12.0-alpine as builder
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
RUN npm ci
RUN npm install
COPY . ./
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]