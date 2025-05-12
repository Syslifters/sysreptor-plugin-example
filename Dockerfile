ARG SYSREPTOR_VERSION="latest"

# Optional build stage for frontend assets
FROM node:alpine AS plugin-builder

RUN apk add --no-cache \
    bash \
    git \
    curl \
    wget \
    unzip \ 
    jq \
    inotify-tools

# Initialize sysreptor plugin packages
COPY sysreptor-src/packages /build/sysreptor-src/packages
RUN cd /build/sysreptor-src/packages \
    && npm install

# Build frontend assets
COPY custom_plugins /build/custom_plugins
WORKDIR /build/custom_plugins
RUN /build/custom_plugins/build.sh


# Extend the Sysreptor image with custom plugins
FROM syslifters/sysreptor:${SYSREPTOR_VERSION}
# Optional: install additional dependencies
# RUN pip install ...
ENV PLUGIN_DIRS=${PLUGIN_DIRS},/custom_plugins
COPY --from=plugin-builder /build/custom_plugins /custom_plugins

