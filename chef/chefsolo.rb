root = File.expand_path(File.dirname(__FILE__))

file_cache_path  "/tmp/chef-solo-cache"
cookbook_path    [File.join(root, "cookbooks"),
                  File.join(root, "our_cookbooks")]
role_path        File.join(root, "roles")
data_bag_path     File.join(root, "data_bags")
log_level        :info
log_location     STDOUT
ssl_verify_mode  :verify_none
