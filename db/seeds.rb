# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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


