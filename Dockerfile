FROM alpine:3.3

ENV OPENRESTY_VERSION 1.11.2.2
ENV OPENRESTY_PREFIX /opt/openresty
ENV NGINX_PREFIX /opt/openresty/nginx
ENV VAR_PREFIX /var/nginx

# NginX prefix is automatically set by OpenResty to $OPENRESTY_PREFIX/nginx
# look for $ngx_prefix in https://github.com/openresty/ngx_openresty/blob/master/util/configure
RUN echo "==> Installing dependencies..." \
 && apk update \
 && apk add --update \
    curl unzip \
 && apk add --virtual build-deps \
    make gcc musl-dev \
    pcre-dev openssl-dev zlib-dev ncurses-dev readline-dev \
    curl perl \
    git \
 && mkdir -p /root/ngx_openresty \
 && cd /root/ngx_openresty \
 && echo "==> Downloading OpenResty..." \
 && curl -sSL http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar -xvz \
 && cd openresty-* \
 # renaming server :)
 && perl -pi -e 's/"Server: openresty" CRLF/"Server: Teapot" CRLF/g' bundle/nginx-1.11.2/src/http/ngx_http_header_filter_module.c \
 && perl -pi -e 's/"Server: " NGINX_VER CRLF/"Server: Teapot BETA 1.0" CRLF/g' bundle/nginx-1.11.2/src/http/ngx_http_header_filter_module.c \
 && echo "==> Configuring OpenResty..." \
 && readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && echo "using upto $NPROC threads" \
 && ./configure \
    --prefix=$OPENRESTY_PREFIX \
    --http-client-body-temp-path=$VAR_PREFIX/client_body_temp \
    --http-proxy-temp-path=$VAR_PREFIX/proxy_temp \
    --http-log-path=$VAR_PREFIX/access.log \
    --error-log-path=$VAR_PREFIX/error.log \
    --pid-path=$VAR_PREFIX/nginx.pid \
    --lock-path=$VAR_PREFIX/nginx.lock \
    --with-luajit \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_ssl_module \
    --without-http_ssi_module \
    --without-http_userid_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    -j${NPROC} \
 && echo "==> Building OpenResty..." \
 && make -j${NPROC} \
 && echo "==> Installing OpenResty..." \
 && make install \
 && echo "==> Finishing..." \
 && ln -sf $NGINX_PREFIX/sbin/nginx /usr/local/bin/nginx \
 && ln -sf $NGINX_PREFIX/sbin/nginx /usr/local/bin/openresty \
 && ln -sf $OPENRESTY_PREFIX/bin/resty /usr/local/bin/resty \
 && ln -sf $OPENRESTY_PREFIX/luajit/bin/luajit-* $OPENRESTY_PREFIX/luajit/bin/lua \
 && ln -sf $OPENRESTY_PREFIX/luajit/bin/luajit-* /usr/local/bin/lua \
 && apk add \
    libpcrecpp libpcre16 libpcre32 openssl libssl1.0 pcre libgcc libstdc++ \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/ngx_openresty \
 && cd /tmp/ \
 && wget http://keplerproject.github.io/luarocks/releases/luarocks-2.3.0.tar.gz \
 && tar xvzf luarocks-2.3.0.tar.gz \
 && cd luarocks-2.3.0/ \
 && ./configure --with-lua-include=/opt/openresty/luajit/include/luajit-2.1 \
 && make build \
 && make install

WORKDIR /home/
RUN luarocks install lapis
RUN luarocks install moonscript

WORKDIR $NGINX_PREFIX/
COPY lapis_app $OPENRESTY_PREFIX/nginx/conf
RUN moonc .
WORKDIR $NGINX_PREFIX/conf
RUN lapis build
COPY entrypoint.sh /
RUN chmod 700 /entrypoint.sh

ENTRYPOINT ["sh"]
CMD ["/entrypoint.sh"]
