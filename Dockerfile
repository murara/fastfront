FROM openresty/openresty:latest-xenial

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl

COPY nginx-cache-purge /nginx-cache-purge
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf;

ENTRYPOINT ["sh","/docker-entrypoint.sh"]
CMD ["/usr/local/openresty/nginx/sbin/nginx", "-g", "daemon off;"]