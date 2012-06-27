maintainer       ""
maintainer_email ""
license          "Apache 2.0"
description      "Deploys and configures a variety of cmsapps defined from databag 'apps'"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "cmsapp", "Loads cmsapp databags and selects recipes to use"
recipe           "cmsapp::mod_php_apache2", "Sets up a deployed PHP cmsapp as a mod_php virtual host in Apache2"
recipe           "cmsapp::php_pear_module_install", "Deploys a PHP cmsapp specified in a data bag with the deploy_revision resource"

%w{ apache2 php_pear_module_install }.each do |cb|
  depends cb
end
