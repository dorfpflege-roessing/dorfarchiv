# --- Stage 1: Build the static Docusaurus site ---
FROM node:22-alpine@sha256:0e1754758c2df4cfa3e68d59e2e1b7374bb7fd9ea6328eaaacf15cc934af8202 AS build
WORKDIR /app

# Abhängigkeiten zuerst (Layer-Cache)
COPY package.json package-lock.json* ./
RUN npm ci

# Quellcode kopieren und statisch bauen
COPY . .
RUN npm run build

# --- Stage 2: Serve build/ via nginx ---
FROM nginx:alpine@sha256:713fc2ebfd92e8217db451477182ee91944b123d2b1ee9fd5a8c6e91ca6c3a11 AS runtime
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
