task :contracted_data => :environment do
  spreadsheet = Roo::Spreadsheet.open(ENV['CONTRACTS_FILE_PATH_LOCAL'])
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    #================  Company start ======================================================
    company = Company.find_by_company_name(row['Name'])
    if not company.present?
      company = Company.new
      company.created_at   = row['Contract Date']
      company.updated_at   = row['Contract Date']
      company.company_name = row['Name']
      company.contact_name = row['Contact Name']
      company.contact_phone= row['Contact Phone']
      company.company_status   = 'contracted'
      company.number_of_outlets= row['Outlet# at pick']
      company.save!
    end
    # ================  Company end  ======================================================
    
    # ========================================================================
    state = State.find_by_name('Punjab')
    city  = City.find_by_name(row['City']) || City.new
    if city.new_record?
      city.name     = row['City']
      city.state_id = state.id
      city.save!
    end
    
    if row['Area'].present?
      area = Area.find_by_name(row['Area']) || Area.new
      if area.new_record?
        area.name    = row['Area']
        area.city_id = city.id
        area.state_id= state.id
        area.save!
      end
    end
    
    if row['Storage Tin/Drum'].present?
      storage_type = StorageType.find_by_name(row['Storage Tin/Drum']) || StorageType.new
      if storage_type.new_record?
        storage_type.name = row['Storage Tin/Drum']
        storage_type.save!
      end
    end
    
    if row['Type'].present?
      food_type = FoodType.find_by_name(row['Type']) || FoodType.new
      if food_type.new_record?
        food_type.name = row['Type']
        food_type.save!
      end
    end

    if row['FSO Name'].present?
      email= "#{row['FSO Name'].downcase.gsub(' ', '_')}@gmail.com"
      role = Role.find_by_name('saler')
      user = User.find_by_email(email) || User.new
      if user.new_record?
        user.name     = row['FSO Name']
        user.email    = email
        user.password = '1234567890'
        user.password_confirmation = '1234567890'
        user.role_id  = role.id
        user.save!
      end
    end
    # ========================================================================
    
    # ================  Branch  start  ========================================
    branch = Branch.new
    branch.company_id   = company ? company.id : nil
    branch.branch_name  = row['Name']
    branch.contact_name = row['Outlet Contact Name']
    branch.contact_phone= row['Outlet Contact Phone']
   
    branch.monthly_oil_used  = row['Total Oil Monthly KG']
    branch.street      = row['Outlets/pickup Address']
    branch.created_at   = row['Lead creation date']
    branch.zip          = 54000
    branch.area_id      = area ? area.id : nil
    branch.storage_type_id = storage_type ? storage_type.id : nil
    branch.food_type_id    = food_type ? food_type.id : nil
    branch.city_id       = city.id
    branch.state_id      = state.id
    branch.branch_status = 'contracted'
    branch.representative= user ? user.id : nil
    branch.rate_per_kg   = row['Rate']
    branch.save(validate: false)
    branch.update_status_and_code
    # ================  Branch  end  ========================================
  end
end