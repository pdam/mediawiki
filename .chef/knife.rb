current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
client_key               "#{current_dir}/pratikdam.pem"
validation_client_name   "devp-validator"
validation_key           "#{current_dir}/devp-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/devp"
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:aws_access_key]=           "AKIAJUZZ2SVYZWN7K2OA"
knife[:aws_secret_access_key]  =   "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"
knife[:aws_ssh_key_id]    =        "pratikdam" 
node_name            "pratikdam"
