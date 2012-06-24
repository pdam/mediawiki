current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "pratikdam"
client_key               "#{current_dir}/pratikdam.pem"
validation_client_name   "devp-validator"
validation_key           "#{current_dir}/devp-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/devp"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:aws_access_key]=           "AKIAJVHGSMBQFAGITDEQ"
knife[:aws_secret_access_key]  =   "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"
knife[:aws_ssh_key]    =           "AKIAJVHGSMBQFAGITDEQ"
node_name           =  "ec2-23-21-1-145.compute-1.amazonaws.com"
