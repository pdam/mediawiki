
require 'rubygems'
require 'chef'
require 'json'

# Load constants from rake config file.
require File.join(File.dirname(__FILE__), 'config', 'rake')
 if File.directory?(File.join(TOPDIR, ".svn"))
   $vcs = :svn
   elsif File.directory?(File.join(TOPDIR, ".git"))
     $vcs = :git
     end

     # Load common, useful tasks from Chef.
     # rake -T to see the tasks this loads.

     load 'chef/tasks/chef_repo.rake'

     desc "Bundle a single cookbook for distribution"
     task :bundle_cookbook => [ :metadata ]
     task :bundle_cookbook, :cookbook do |t, args|
       tarball_name = "#{args.cookbook}.tar.gz"
         temp_dir = File.join(Dir.tmpdir, "chef-upload-cookbooks")
           temp_cookbook_dir = File.join(temp_dir, args.cookbook)
             tarball_dir = File.join(TOPDIR, "pkgs")
               FileUtils.mkdir_p(tarball_dir)
                 FileUtils.mkdir(temp_dir)
                   FileUtils.mkdir(temp_cookbook_dir)

                     child_folders = [ "cookbooks/#{args.cookbook}", "site-cookbooks/#{args.cookbook}" ]
                       child_folders.each do |folder|
                           file_path = File.join(TOPDIR, folder, ".")
                               FileUtils.cp_r(file_path, temp_cookbook_dir) if File.directory?(file_path)
                                 end

                                   system("tar", "-C", temp_dir, "-cvzf", File.join(tarball_dir, tarball_name), "./#{args.cookbook}")

                                     FileUtils.rm_rf temp_dir
                                     end


