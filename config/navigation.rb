SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class      = 'nav side-menu'
    primary.selected_class = 'active'
    
    if @current_user_role == AppConstants::SUPER_ADMIN
      primary.item :users, content_tag(:i, "", :class => "fa fa-users") + "Add User", new_user_path, :highlights_on => /\/users/
      primary.item :sites, content_tag(:i, "", :class => "fa fa-users") + "Sites", sites_path, :highlights_on => /\/sites/
    end
    
    if AppConstants::SETTING_ARRAY.include? @current_user_role
      
    end
    if @current_user_site.present? && @current_user_role != AppConstants::PFA
      if @current_user_site.is_automate_process
        primary.item :users, content_tag(:i, "", :class => "fa fa-users") + "Users", users_path, :highlights_on => /\/users/
        if AppConstants::SETTING_ARRAY.include? @current_user_role
          primary.item :settings, content_tag(:i, "", :class => "fa fa-users") + "Settings", "#" do |secondary|
            secondary.dom_class = 'sub-menu'
            secondary.item :storage_types, content_tag(:i, "", :class => "fa fa-users") + "Storage Types", storage_types_path, :highlights_on => /\/storage_types/
            secondary.item :food_types, content_tag(:i, "", :class => "fa fa-users") + "Food Types", food_types_path, :highlights_on => /\/food_types/
            secondary.item :companies, content_tag(:i, "", :class => "fa fa-users") + "Companies", companies_path, :highlights_on => /\/companies/
            secondary.item :vehicles, content_tag(:i, "", :class => "fa fa-users") + "Vehicles", vehicles_path, :highlights_on => /\/vehicles/
            secondary.item :billings, content_tag(:i, "", :class => "fa fa-users") + "Billings", billings_path, :highlights_on => /\/billings/
          end
        end
        if AppConstants::BRANCH_ARRAY.include? @current_user_role
          primary.item :branches, content_tag(:i, "", :class => "fa fa-users") + "Branches", "#" do |secondary|
            secondary.dom_class = 'sub-menu'
            secondary.item :new_branch, content_tag(:i, "", :class => "fa fa-users") + "New branch", new_branch_path, :highlights_on => /\/branches/
            secondary.item :leads, content_tag(:i, "", :class => "fa fa-users") + "Leads", branches_path({ type: 'lead' }), :highlights_on => /\/branches/
            secondary.item :contracts, content_tag(:i, "", :class => "fa fa-users") + "Contracts", branches_path({ type: 'contracted' }), :highlights_on => /\/branches/
          end
          primary.item :routes, content_tag(:i, "", :class => "fa fa-users") + "Routes", "#" do |secondary|
            secondary.dom_class = 'sub-menu'
            secondary.item :new_route, content_tag(:i, "", :class => "fa fa-users") + "New route", new_route_path, :highlights_on => /\/routes/
            secondary.item :active_routes, content_tag(:i, "", :class => "fa fa-users") + "Active routes", routes_path({ type: 'active' }), :highlights_on => /\/routes/
            secondary.item :completed_routes, content_tag(:i, "", :class => "fa fa-users") + "Completed routes", routes_path({ type: 'completed' }), :highlights_on => /\/routes/
          end
        end
        if AppConstants::ASSIGNMENT_ARRAY.include? @current_user_role
          primary.item :assignments, content_tag(:i, "", :class => "fa fa-users") + "Assignments", "#" do |secondary|
            secondary.dom_class = 'sub-menu'
            secondary.item :new_assignment, content_tag(:i, "", :class => "fa fa-users") + "New assignment", new_assignment_path, :highlights_on => /\/assignemnts/
            secondary.item :active_assignments, content_tag(:i, "", :class => "fa fa-users") + "Active assignments", assignments_path({ type: 'active' }), :highlights_on => /\/assignemnts/
            if AppConstants::FACTORY_ARRAY.include? @current_user_role
              secondary.item :factory_assignments, content_tag(:i, "", :class => "fa fa-users") + "Factory assignments", factory_assignments_assignments_path(), :highlights_on => /\/assignemnts/
            end
            secondary.item :completed_assignments, content_tag(:i, "", :class => "fa fa-users") + "Completed assignments", assignments_path({ type: 'completed' }), :highlights_on => /\/assignemnts/
          end
        end
        
        if AppConstants::REPORT_ARRAY.include? @current_user_role
          primary.item :reports, content_tag(:i, "", :class => "fa fa-users") + "Reports", reports_path, :highlights_on => /\/reports/
        end
        
        if AppConstants::FACTORY_ARRAY.include? @current_user_role
          primary.item :factory_collections, content_tag(:i, "", :class => "fa fa-users") + "Factory Collection", factory_collections_path, :highlights_on => /\/factory_collections/
        end
        
        if AppConstants::SETTING_ARRAY.include? @current_user_role
          primary.item :urgent_actions, content_tag(:i, "", :class => "fa fa-users") + "Urgent Actions", notes_path, :highlights_on => /\/notes/
        end
        
        primary.item :product_sale, content_tag(:i, "", :class => "fa fa-users") + "Product Sale", product_sales_path, :highlights_on => /\/product_sales/
      else
        primary.item :users, content_tag(:i, "", :class => "fa fa-users") + "Add User", new_user_path, :highlights_on => /\/users/
        primary.item :new_branch, content_tag(:i, "", :class => "fa fa-users") + "Add Client", new_branch_path, :highlights_on => /\/branches/
        primary.item :add_collection, content_tag(:i, "", :class => "fa fa-users") + "Add Collection", new_factory_collection_path, :highlights_on => /\/factory_collections/
        primary.item :product_sale, content_tag(:i, "", :class => "fa fa-users") + "Product Sale", new_product_sale_path, :highlights_on => /\/product_sales/
      end
    elsif @current_user_role == AppConstants::PFA
      primary.item :users, content_tag(:i, "", :class => "fa fa-users") + "Add User", new_user_path, :highlights_on => /\/users/
      primary.item :reports, content_tag(:i, "", :class => "fa fa-users") + "Summary Report", generate_report_reports_path({format: 'pdf', report_type: AppConstants::SUMMARY_REPORT}), :highlights_on => /\/reports/
      if session[:current_user_site].present?
        if not session[:current_user_site]['is_automate_process']
          primary.item :new_branch, content_tag(:i, "", :class => "fa fa-users") + "Add Client", new_branch_path, :highlights_on => /\/branches/
          primary.item :add_collection, content_tag(:i, "", :class => "fa fa-users") + "Add Collection", new_factory_collection_path, :highlights_on => /\/factory_collections/
          primary.item :product_sale, content_tag(:i, "", :class => "fa fa-users") + "Product Sale", new_product_sale_path, :highlights_on => /\/product_sales/
        end
      end
    end
  end
end

#primary.item :secondary, content_tag(:span, "Help", :class => "top_menu_bg"), quick_helps_url(:role_key => "Manager"), :highlights_on => /\/quick_helps|\/quick_help_questions/ do |secondary|
#  secondary.item :help_managers, content_tag(:span, 'Manager', :class => "top_menu_bg"), quick_helps_url(:role_key => "Manager"), :highlights_on => Proc.new { (params[:role_key] == "Manager" && on_controller?("quick_helps")) }
#  secondary.item :help_contractors, content_tag(:span, 'Service Provider', :class => "top_menu_bg"), quick_helps_url(:role_key => "Service Provider"), :highlights_on => Proc.new { (params[:role_key] == "Service Provider" && on_controller?("quick_helps")) }
#end

#primary.item :mail_boxes, content_tag(:span, 'Mail Box', :class => "top_menu_bg"), mail_boxes_url(), :highlights_on => /\/mail_boxes/
#primary.item :admin_profiles, content_tag(:span, 'My Profile', :class => "top_menu_bg"), edit_admin_profile_url(current_user.profile), :highlights_on => lambda { @admin_profile.present? }
