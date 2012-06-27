default[:yum][:exclude]
default[:yum][:installonlypkgs]

default['yum']['epel_release'] = case node['platform_version'].to_i
                                  when 6
                                    "6-5"
                                  when 5
                                    "5-4"
                                  when 4
                                    "4-10"
                                  end
default['yum']['ius_release'] = '1.0-8'
