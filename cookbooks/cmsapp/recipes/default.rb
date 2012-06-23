
search(:apps) do |app|
  (app["server_roles"] & node.run_list.roles).each do |app_role|
    app["type"][app_role].each do |thing|
      node.run_state[:current_app] = app
      include_recipe "application::#{thing}"
    end
  end
end

node.run_state.delete(:current_app)

