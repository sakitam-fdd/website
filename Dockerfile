FROM node:14-slim as builder
RUN apt-get update && apt-get install -y jq curl wget python unzip git
WORKDIR /app

# https://cn.arip-photo.org/170029-unzipping-files-that-are-flying-AWUNGO
### Get the latest release source code tarball
#RUN wget -qO- https://github.com/sakitam-fdd/website/archive/refs/heads/sakitam.zip \
#    | busybox unzip -

RUN wget -q -O tmp.zip https://github.com/sakitam-fdd/website/archive/refs/heads/master.zip && unzip tmp.zip && cp -r website-master/* ./ && rm tmp.zip

RUN ls -a

RUN git clone https://github.com/sakitam-fdd/hexo-theme-n2.git themes/next

### --network-timeout 1000000 as a workaround for slow devices
### when the package being installed is too large, Yarn assumes it's a network problem and throws an error
RUN yarn --network-timeout 1000000

### Separate `yarn build` layer as a workaround for devices with low RAM.
### If build fails due to OOM, `yarn install` layer will be already cached.
RUN yarn generate

RUN cd dist && ls -l

### Nginx or Apache can also be used, Caddy is just smaller in size
FROM caddy:latest as release
COPY ./Caddyfile /etc/caddy/Caddyfile
COPY --from=builder /app/dist /usr/share/caddy

EXPOSE 80 443
