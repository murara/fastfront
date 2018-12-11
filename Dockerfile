FROM openresty/openresty:alpine-fat

RUN apk add openssl pcre pcre-dev \
 && /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl \
 && /usr/local/openresty/luajit/bin/luarocks install lrexlib-PCRE \
 && curl -L https://raw.githubusercontent.com/yourpalmark/mobile-detect.lua/master/mobile-detect.lua -o /usr/local/openresty/lualib/mobile-detect.lua \
 && openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -subj '/CN=sni-support-required-for-valid-ssl' -keyout /etc/ssl/resty-auto-ssl-fallback.key -out /etc/ssl/resty-auto-ssl-fallback.crt \
 && apk del pcre-dev \
 && rm -rf /var/cache/apk \
 && rm -rf /root/.bash_history \
 && rm -rf /root/.rnd \
 && rm -rf /usr/local/openresty/luajit/lib/luarocks/rocks/lrexlib-pcre/2.9.0-1/doc \
 && rm -rf /usr/local/openresty/luajit/lib/luarocks/rocks/lua-resty-auto-ssl/0.12.0-1/doc \
 && rm -rf /usr/local/openresty/luajit/lib/luarocks/rocks/lua-resty-http/0.12-0/doc

COPY nginx-cache-purge /nginx-cache-purge
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
