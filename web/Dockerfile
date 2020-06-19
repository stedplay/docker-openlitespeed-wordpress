ARG WEB_SERVER_VERSION
ARG WEB_PHP_VERSION
from litespeedtech/openlitespeed:${WEB_SERVER_VERSION}-lsphp${WEB_PHP_VERSION}

# args
ARG WEB_PHP_UPLOAD_MAX_FILESIZE

# Set upload max filesize before starting web server.
RUN php_ini_path=$(php --ini | grep 'Loaded Configuration File:' | grep -o /.*php.ini) && \
  cp -p ${php_ini_path} ${php_ini_path}_org && \
  sed -i "s/^post_max_size = .*$/post_max_size = ${WEB_PHP_UPLOAD_MAX_FILESIZE}/" ${php_ini_path}  && \
  sed -i "s/^upload_max_filesize = .*$/upload_max_filesize = ${WEB_PHP_UPLOAD_MAX_FILESIZE}/" ${php_ini_path}

COPY ./script/cmd.sh /cmd.sh
RUN chmod +x /cmd.sh
CMD ["/cmd.sh"]
