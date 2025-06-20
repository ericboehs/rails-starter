# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user for development
if Rails.env.development?
  admin_user = User.find_or_create_by!(email_address: "admin@example.com") do |user|
    user.password = "password"
    user.admin = true
  end

  puts "Created admin user: #{admin_user.email_address}"
  puts "Password: password"
  puts "Admin: #{admin_user.admin?}"
end
