# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
########################################################################################

# You can have finer control with:
# rails db:drop

# And then create the database without running the migrations:
# rails db:create

# Then run all your migrations:
# rails db:migrate

# If you have some seeds data, run:
# rails db:seed

# The below might not be relevant in production
if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: "REACT client", redirect_uri: "", scopes: "", uid: "TT77nahIltTMwQZGJZQVvGRzsQv_H9xAtvREdA6IRm0", secret: "DYLuIiq-5Fq-dtyM7Bcvi1wlHEclmA0dxeU4ng7eLAU")
end

if Faq.count.zero?
  Faq.create(question: "How to delete my account?", response: "You can delete your account at anytime using your profile configuration page.", keywords: ["delete my account", "remove", "quit"])
end

# if User.count.zero?
#   User.create(email: "tcheetoz@gmail.com", password: "Leader009")
#   User.create(email: "tcheetox@gmail.com", password: "Leader009")
#   User.create(email: "tcheetoy@gmail.com", password: "Leader009")
# end