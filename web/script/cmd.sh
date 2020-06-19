document_root_path=/var/www/vhosts/localhost/html/
wordpress_siteurl_path=${document_root_path%/}${WORDPRESS_SITEURL_DIR%/}/
wordpress_home_path=${document_root_path%/}${WORDPRESS_HOME_DIR%/}/
wordpress_install_dir=${WORDPRESS_SITEURL_DIR#${WORDPRESS_HOME_DIR%/}}
wordpress_scheme_authority=${WEB_HTML_SCHEME}://${WEB_HTML_FQDN}:${WEB_HTML_PORT}
wordpress_siteurl_url=${wordpress_scheme_authority}${WORDPRESS_SITEURL_DIR}
wordpress_home_url=${wordpress_scheme_authority}${WORDPRESS_HOME_DIR}

if ${WORDPRESS_INITIAL_INSTALL} && ! wp core is-installed --path=${wordpress_siteurl_path} --allow-root; then
  # Download wordpress.
  mkdir -p ${wordpress_siteurl_path}
  cd ${wordpress_siteurl_path}
  wp core download --version=${WORDPRESS_VERSION} --locale=${LOCALE} --allow-root
  # Wait for DB to be ready.
  while :
  do
    db_ping=$(mysqladmin ping --user=${DB_USER} --password=${DB_PASSWORD} --host=${DB_HOST} 2>&1)
    if echo "${db_ping}" | grep 'alive'; then
      break
    fi
    sleep 1s
  done
  # Create 'wp-config.php'.
  wp core config --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=${DB_HOST} --dbprefix=${DB_PREFIX} --allow-root
  # Install wordpress.
  wp core install --title=${WORDPRESS_TITLE} --admin_user=${WORDPRESS_USER} --admin_password=${WORDPRESS_PASSWORD} --admin_email=${WORDPRESS_EMAIL} --url=${wordpress_siteurl_url} --allow-root

  # Make it possible to access using only the domain.
  cp -p ./index.php ${wordpress_home_path}
  sed -i "s#/wp-blog-header.php#${wordpress_install_dir%/}/wp-blog-header.php#" ${wordpress_home_path}index.php
  wp option update home ${wordpress_home_url} --allow-root

  # To avoid Connection Information dialog when installing plugin,
  # change owner of document root and wp-admin/includes/file.php to lsadm.
  chown --recursive lsadm:lsadm ${document_root_path}
  /usr/local/lsws/bin/lswsctrl restart
fi
