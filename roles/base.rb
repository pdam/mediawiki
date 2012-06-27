name "base"
description "Base role applied to all nodes."
run_list(
  "recipe[zsh]",
  "recipe[users::sysadmins]",
  "recipe[sudo]",
  "recipe[yum]",
  "recipe[git]",
  "recipe[build-essential]"
)
override_attributes(
  :authorization => {
    :sudo => {
      :users => ["ubuntu", "ec2-user"],
      :passwordless => true
    }
  }
)
