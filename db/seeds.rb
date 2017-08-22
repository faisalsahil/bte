
states = ['Punjab', 'Sindh', 'KPK', 'Balochistan', 'Azad Kashmir', 'Gilgit', 'FATA']

states.each do |state|
  new_state = State.create!(name: state)
  if state == 'Punjab'
    cities = CS.cities(:pb, :pk)
    cities << 'Islamabad'
  end

  if state == 'Sindh'
    cities = CS.cities(:sd, :pk)
  end

  if state == 'KPK'
    cities = CS.cities(:nw, :pk)
  end

  if state == 'Balochistan'
    cities = CS.cities(:ba, :pk)
  end

  if state == 'Azad Kashmir'
    cities = CS.cities(:jk, :pk)
  end

  if state == 'Gilgit'
    cities = CS.cities(:na, :pk)
  end

  if state == 'FATA'
    cities = CS.cities(:ta, :pk)
  end
  
  cities.each do |city|
    City.create!(state_id: new_state.id, name: city)
  end
end



# 'Islamabad'
roles = [AppConstants::SUPER_ADMIN, AppConstants::ADMIN, AppConstants::DRIVER, AppConstants::HELPER, AppConstants::FACTORY, AppConstants::SALER, AppConstants::PFA, AppConstants::ACCOUNTANT]

roles.each do |role|
  Role.create!(name: role)
end

user = User.new
user.email  = 'admin@gmail.com'
user.name   = 'admin'
user.role_id= Role.find_by_name('Super admin').id
user.password              = 'admin123'
user.password_confirmation = 'admin123'
user.save!


user = User.new
user.email  = 'pfa@gmail.com'
user.name   = 'PFA'
user.role_id= Role.find_by_name('pfa').id
user.password              = 'admin123'
user.password_confirmation = 'admin123'
user.save!





