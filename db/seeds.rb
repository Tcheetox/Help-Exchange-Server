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
  Faq.create(question: "I had an issue while helping someone, what should I do?", response: "Contact our support by email so we can take necessary measures if needed.", keywords: ["issues", "support", "email"])
  Faq.create(question: "I created an account but I cannot help and/or ask for assistance, why?", response: "Before using our services your profile must be complete. You can complete it in your profile configuration page.", keywords:["complete profile"])
  Faq.create(question: "How do I communicate with the person in needs of help?", response: "Once you have subscribed to a help request, you can start chatting with the owner by clicking his profile in your requests' dashboard.", keywords:["chat", "communication", "message", "dashboard"])
  Faq.create(question: "Can I chat with the other participants?", response: "No, only the owner of a help request can communicate with all the participants. As a participant, you can only start the conversation with the owner.", keywords:["chat", "communication", "owner", "participant"])
  Faq.create(question: "What happens if I remove information from my previously complete profile?", response: "At Fish For Help, we value your privacy and you can delete and/or change your information at anytime. However, keep in mind that your profile must always be complete if you still want to use our services.", keywords:["profile, complete, completeness, information, privacy"])
  Faq.create(question: "Can I ask for money?", response: "No! This platform must remain free of charges, both for its use and in its content. Any violations of our Terms and Services will lead to account suspension.", keywords: ["money", "terms and services", "chart","violation"])
end

# if User.count.zero?
#   User.create(email: "tcheetoz@gmail.com", password: "Leader009")
#   User.create(email: "tcheetox@gmail.com", password: "Leader009")
#   User.create(email: "tcheetoy@gmail.com", password: "Leader009")
# end