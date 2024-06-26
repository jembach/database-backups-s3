# Build Stage
FROM alpine:3.19 AS build

WORKDIR /root

RUN apk add --update --no-cache nodejs npm

COPY package*.json ./

RUN npm install
RUN npm prune --production

# Final Stage
FROM alpine:3.19

ENV ENABLE_ALPINE_PRIVATE_NETWORKING="true"

WORKDIR /root

# Copy from build stage
COPY --from=build /root/node_modules ./node_modules

# Copy application code
COPY ./ /root

# Install PostgreSQL, MySQL and MongoDB clients
RUN apk add --update --no-cache postgresql16-client mysql-client mongodb-tools nodejs npm gnupg

ENTRYPOINT ["node", "index.js"]
