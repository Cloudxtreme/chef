#!/bin/sh
PHP_FCGI_CHILDREN=12
export PHP_FCGI_CHILDREN
PHP_FCGI_MAX_REQUESTS=500
export PHP_FCGI_MAX_REQUESTS
exec /usr/local/php/bin/php-cgi -c /usr/local/lib/php.ini
