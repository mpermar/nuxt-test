# syntax = docker/dockerfile:1

ARG NODE_VERSION=20.18.0

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
FROM us-east1-docker.pkg.dev/vmw-app-catalog/hosted-registry-761e85bef74/containers/photon-5/node-min:22.12.0-photon-5-r0 

ENV PORT=$PORT
ENV NODE_ENV=production

COPY --from=build /src/.output /src/.output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build /src/node_modules /src/node_modules

CMD [ "node", ".output/server/index.mjs" ]
