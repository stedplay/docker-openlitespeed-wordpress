document_root_path=/var/www/vhosts/localhost/html/
wordpress_siteurl_path=${document_root_path%/}${WORDPRESS_SITEURL_DIR%/}/

if ! wp core is-installed --path=${wordpress_siteurl_path} --allow-root; then
  # Download wordpress.
  mkdir -p ${wordpress_siteurl_path}
  cd ${wordpress_siteurl_path}
  wp core download --version=${WORDPRESS_VERSION} --locale=${LOCALE} --allow-root
fi
