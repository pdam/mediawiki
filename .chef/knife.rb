current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
client_key               "#{current_dir}/mediawiki.pem"
validation_client_name   "devp-validator"
validation_key           "#{current_dir}/devp-validator.pem"
chef_server_url          "https://10.28.32.95:4000"
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:aws_access_key_id]=           "AKIAJJ4V2FMJOFQY52XQ"
knife[:aws_secret_access_key]  =   "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"
knife[:aws_ssh_key_id] = "mediawiki"
node_name            "pratikdam"
