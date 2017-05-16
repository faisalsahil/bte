# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
roles = ['Super admin', 'admin', 'driver', 'factory']

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





