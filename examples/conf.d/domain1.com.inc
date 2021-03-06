set $do_not_cache 0;
set $bypass 0;

#security for bypass
if ($remote_addr ~ "^(127.0.0.1|???.???.???.???)$") {   # REPLACE WITH YOUR BACKEND IP ADDRESS
    set $bypass $http_secret_header;
}

# EXAMPLE FOR WORDPRESS COOKIES, YOU CAN PLACE YOURS
if ($http_cookie ~* "comment_author_|wordpress_(?!test_cookie)|wp-postpass_" ) {
    set $do_not_cache 1;
}

location / {
    proxy_cache DYNAMIC;
    proxy_cache_revalidate on;
    proxy_ignore_headers X-Accel-Expires Expires Cache-Control Vary;
    proxy_cache_use_stale  error timeout invalid_header updating http_500 http_502 http_503 http_504;
    proxy_cache_min_uses 3;
    proxy_http_version 1.1;
    proxy_ignore_client_abort on;

    proxy_no_cache $do_not_cache;
    proxy_cache_bypass $bypass $do_not_cache;
    proxy_cache_valid 200 24h;
    proxy_cache_valid 404 1m;
    proxy_cache_lock on;
    proxy_pass http://???.???.???.???; # REPLACE WITH YOUR BACKEND URL
}

location ~ "(/wp-(?!content)|/index.php)" {
    proxy_no_cache 1;
    proxy_cache_bypass 1;
    proxy_pass http://???.???.???.???; # REPLACE WITH YOUR BACKEND URL
}

location ~ /purge(/.*) {
    allow 127.0.0.1;
    allow ???.???.???.???; # REPLACE WITH YOUR BACKEND IP ADDRESS
    deny all;
    set $exec "/nginx-cache-purge ";
    set $param1 "${scheme}${host}$1";
    set $param2 " /var/run/proxy_cache";
    content_by_lua "os.execute(ngx.var.exec .. ngx.var.param1 .. ngx.var.param2)";
}

location ~* \.(?:css|js|jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
    proxy_cache STATIC;
    proxy_cache_revalidate on;
    proxy_ignore_headers X-Accel-Expires Expires Cache-Control Vary;
    proxy_cache_use_stale error timeout invalid_header updating http_500 http_502 http_503 http_504;
    proxy_cache_min_uses 1;
    proxy_http_version 1.1;
    proxy_ignore_client_abort on;

    proxy_cache_valid 200 7d;
    proxy_cache_valid 404 1m;
    proxy_cache_lock on;
    proxy_pass http://???.???.???.???; # REPLACE WITH YOUR BACKEND URL
}

# Endpoint used for performing domain verification with Let's Encrypt.
location /.well-known/acme-challenge/ {
    content_by_lua_block {
        auto_ssl:challenge_server()
    }
}
