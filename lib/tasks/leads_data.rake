task :leads_data => :environment do
  spreadsheet = Roo::Spreadsheet.open(ENV['LEADS_FILE_PATH_LOCAL'])
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    #================  Company start ======================================================
    company = Company.find_by_company_name(row['Name'])
    if not company.present?
      company = Company.new
      company.created_at   = row['Lead creation date']
      company.updated_at   = row['Lead creation date']
      company.company_name = row['Name']
      company.contact_name = row['Contact Name']
      company.contact_phone= row['Contact Phone']
      company.contact_email= row['Email Address']
      company.company_status   = 'lead'
      company.number_of_outlets= row['Outlets']
      company.save!
    end
    # ================  Company end   ======================================================
    
    
    # ========================================================================
    storage_type = StorageType.find_by_name(row['Storage Tin Drum']) || StorageType.new
    if storage_type.new_record?
      storage_type.name = row['Storage Tin Drum']
      storage_type.save!
    end
    
    food_type = FoodType.find_by_name(row['Type']) || FoodType.new
    if food_type.new_record?
      food_type.name = row['Type']
      food_type.save!
    end
    
    email= "#{row['BTE Person'].downcase.gsub(' ', '_')}@gmail.com"
    role = Role.find_by_name('saler')
    user = User.find_by_email(email) || User.new
    if user.new_record?
      user.name     = row['BTE Persons']
      user.email    = email
      user.password = '1234567890'
      user.password_confirmation = '1234567890'
      user.role_id  = role.id
      user.save!
    end
    # ========================================================================
    
    
    # ================  Branch  start ========================================
    branch = Branch.new
    branch.company_id   = company.id
    branch.branch_name  = row['Name']
    branch.contact_name = row['Contact Name']
    branch.contact_phone= row['Contact Phone']
    branch.contact_email= row['Email Address']
    branch.monthly_oil_used  = row['Total Oil Monthly KG']
    branch.address      = 'Lahore'
    branch.created_at   = row['Lead creation date']
    # branch.zip          = 54000
    # branch.area_id      = area.id
    branch.storage_type_id = storage_type.id
    branch.food_type_id    = food_type.id
    # branch.city_id       = city.id
    # branch.state_id      = state.id
    branch.branch_status = 'lead'
    branch.representative= user.id
    branch.save(validate: false)
  end
end