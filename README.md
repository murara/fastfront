# FastFront

## Description

Fast Front is an open source reverse proxy cache server with automated SSL using [Let's Encrypt](https://letsencrypt.org/). It caches static and dynamic content separated and also you can automate the purge.

The project is based on [OpenResty](https://github.com/openresty/openresty) and uses [Lua](https://github.com/lua/lua) to automate SSL and purge the cache.

## Features

- Automated Free SSL
- Automated Purge
- Cache Static and Dynamic Content Separately
- Detect and Cache Mobile and Desktop Separately

## Usage

Place your configs into `/usr/local/openresty/nginx/conf/conf.d`, you can mount a volume to this folder. The OpenResty is configured to read all `*.conf` inside `/usr/local/openresty/nginx/conf/conf.d`.

**Important!** Mount volume to folders `/var/run/proxy_cache` and `/var/run/proxy_cache_statics`, it'll keep the cache files out of the container.

### Configuration

The project is configured to read all `*.conf` inside `/usr/local/openresty/nginx/conf/conf.d`. You can mount a single file or folder to `/usr/local/openresty/nginx/conf/conf.d`.

Use the `conf.d/example.conf` on GitHub (https://github.com/murara/fastfront) to create your own files.

### Running Single Config

Create a config file using the example placed on `conf.d/example.conf` on GitHub (https://github.com/murara/fastfront), and mount it into `/usr/local/openresty/nginx/conf/conf.d`.

```
docker run --name fastfront \
    -p 80:80 \ 
    -p 443:443 \
    -v /path/to/proxy_dynamic_cache_folder:/var/run/proxy_cache \
    -v /path/to/proxy_static_cache_folder:/var/run/proxy_cache_statics \
    -v /path/to/my-config.conf:/usr/local/openresty/nginx/conf/conf.d/my-config.conf \
    -d murara/fastfront
```

### Running Multiple Configs

Create a folder to places your configs file based on  `conf.d/example.conf` on GitHub (https://github.com/murara/fastfront), and mount the folder to `/usr/local/openresty/nginx/conf/conf.d`.


```
docker run --name fastfront \
    -p 80:80 \ 
    -p 443:443 \
    -v /path/to/proxy_dynamic_cache_folder:/var/run/proxy_cache \
    -v /path/to/proxy_static_cache_folder:/var/run/proxy_cache_statics \
    -v /path/to/conf.d:/usr/local/openresty/nginx/conf/conf.d \
    -d murara/fastfront
```

## Purge

You can purge cache content doing a HTTP request in the top of `/purge` path. It works for dynamic and static content.

**Example:**

URL Cached: http://mydomain.com/about

URL To Purge: http://mydomain.com/purge/about

Using cURL: `curl http://mydomain.com/purge/about`


**_Wordpress Tip_**

Use this plugin to automate the purge: [Nginx Proxy Cache Purge](https://wordpress.org/plugins/nginx-proxy-cache-purge/)

## Roadmap

1. Replace external purge script for Lua