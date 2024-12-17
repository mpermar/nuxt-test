# syntax = docker/dockerfile:1

ARG NODE_VERSION=22.12.0

FROM bitnami/node:${NODE_VERSION} as base

ARG PORT=3000

WORKDIR /src

# Build
FROM base as build

COPY --link package.json package-lock.json .
RUN npm install

COPY --link . .

RUN npm run build

# Run
FROM gcr.io/bitnami-labs/node-min:22.12.0-photon-5-r1

ENV PORT=$PORT
ENV NODE_ENV=production

COPY --from=build /src/.output /src/.output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build /src/node_modules /src/node_modules

CMD [ "node", ".output/server/index.mjs" ]
