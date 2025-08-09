# Create initial admin user for development/demo
if ENV["SEED_ADMIN_EMAIL"].present?
  email = ENV["SEED_ADMIN_EMAIL"]
  password = ENV["SEED_ADMIN_PASSWORD"] || "Password123!"
  user = User.find_or_initialize_by(email: email)
  user.password = password
  user.password_confirmation = password
  user.role = :admin if user.respond_to?(:role)
  user.save!
  puts "Seeded admin user: #{email}"
end
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
