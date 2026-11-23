# --- Stage 1: Build the static Docusaurus site ---
FROM node:22-alpine@sha256:1314fb30ec37592d5845e5a160d522c0e680972aa534549940b8d73bde88481a AS build
WORKDIR /app

# Abhängigkeiten zuerst (Layer-Cache)
COPY package.json package-lock.json* ./
RUN npm ci

# Quellcode kopieren und statisch bauen
COPY . .
RUN npm run build

# --- Stage 2: Serve build/ via nginx ---
FROM nginx:alpine@sha256:fb4658584bd9a916ffb6f6e365f97c25cfdb2923801f551ea08356e695f14ff7 AS runtime
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
