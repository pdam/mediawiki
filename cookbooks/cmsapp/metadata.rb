maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Deploys and configures a variety of applications defined from databag 'apps'"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.99.12"
recipe           "application", "Loads application databags and selects recipes to use"
recipe           "application::mod_php_apache2", "Sets up a deployed PHP application as a mod_php virtual host in Apache2"
recipe           "application::php", "Deploys a PHP application specified in a data bag with the deploy_revision resource"

%w{ runit  apache2 php }.each do |cb|
  depends cb
end
