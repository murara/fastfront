FROM openresty/openresty:alpine-fat

RUN apk add openssl \
 && /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl \
 && openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -subj '/CN=sni-support-required-for-valid-ssl' -keyout /etc/ssl/resty-auto-ssl-fallback.key -out /etc/ssl/resty-auto-ssl-fallback.crt \
 && rm -rf /var/cache/apk \
 && rm -rf /root/.bash_history \
 && rm -rf /root/.rnd \
 && rm -rf /usr/local/openresty/luajit/lib/luarocks/rocks/lua-resty-auto-ssl/0.12.0-1/doc \
 && rm -rf /usr/local/openresty/luajit/lib/luarocks/rocks/lua-resty-http/0.12-0/doc \
 && mkdir -p /usr/local/openresty/lualib/resty/

COPY purge.lua /usr/local/openresty/lualib/resty/purge.lua
COPY t/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
