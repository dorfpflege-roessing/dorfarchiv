# --- Stage 1: Build the static Docusaurus site ---
FROM node:22-alpine@sha256:fe4f6d74e20370acb04ad889077d14d0f64a9c8ea6a42bc60cddf1e844699914 AS build
WORKDIR /app

# Abhängigkeiten zuerst (Layer-Cache)
COPY package.json package-lock.json* ./
RUN npm ci

# Quellcode kopieren und statisch bauen
COPY . .
RUN npm run build

# --- Stage 2: Serve build/ via nginx ---
FROM nginx:alpine@sha256:a3554c0d0b48177b1413c26e01f695334428020d9df01243fbae3e11cfd17417 AS runtime
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
