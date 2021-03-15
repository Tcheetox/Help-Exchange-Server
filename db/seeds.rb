# You can have finer control with:
# rails db:drop
# rails db:create
# rails db:migrate
# rails db:seed
# ULTIMATE
# rails db:drop db:create db:migrate db:seed
# rails db:drop db:create db:migrate db:seed RAILS_ENV=test

# The below might not be relevant in production
if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: "REACT client", redirect_uri: "", scopes: "", uid: ENV['HELPEXCHANGE_APP_ID'], secret: ENV['HELPEXCHANGE_APP_SECRET'])
end

if (Rails.env.development? || Rails.env.test?) && Faq.count.zero?
  Faq.create(question: "How to delete my account?", response: "You can delete your account at anytime using your profile configuration page.", keywords: ["delete my account", "remove", "quit"])
  Faq.create(question: "I had an issue while helping someone, what should I do?", response: "Contact our support by email so we can take necessary measures if needed.", keywords: ["issues", "support", "email"])
  Faq.create(question: "I created an account but I cannot help and/or ask for assistance, why?", response: "Before using our services your profile must be complete. You can complete it in your profile configuration page.", keywords:["complete profile"])
  Faq.create(question: "How do I communicate with the person in needs of help?", response: "Once you have subscribed to a help request, you can start chatting with the owner by clicking his profile in your requests' dashboard.", keywords:["chat", "communication", "message", "dashboard"])
  Faq.create(question: "Can I chat with the other participants?", response: "No, only the owner of a help request can communicate with all the participants. As a participant, you can only start the conversation with the owner.", keywords:["chat", "communication", "owner", "participant"])
  Faq.create(question: "What happens if I remove information from my previously complete profile?", response: "At Fish For Help, we value your privacy and you can delete and/or change your information at anytime. However, keep in mind that your profile must always be complete if you still want to use our services.", keywords:["profile, complete, completeness, information, privacy"])
  Faq.create(question: "Can I ask for money?", response: "No! This platform must remain free of charges, both for its use and in its content. Any violations of our Terms and Services will lead to account suspension.", keywords: ["money", "terms and services", "chart","violation"])
end

if (Rails.env.development? || Rails.env.production?)
  User.create!([
    {id: 101, email: "joe@gmail.com", password: "azerty", confirmed_at: "2021-02-20 09:17:54", confirmation_sent_at: "2021-02-20 09:17:44", first_name: "Joe", last_name: "Tanour", phone: "+32484789546", post_code: "1201", address: "Rue du Mont-Blanc 18", lat: 46.2085, lng: 6.14531, country: "Suisse", completed: true},
    {id: 102, email: "frank@gmail.com", password: "azerty", confirmed_at: "2021-02-20 09:17:54", confirmation_sent_at: "2021-02-20 09:17:44", first_name: "Frank", last_name: "Erzog", phone: "+32484789547", post_code: "1204", address: "Rue du Vieux-Collège 3", lat: 46.2019, lng: 6.15044, country: "Suisse", completed: true},
    {id: 103, email: "tony@gmail.com", password: "azerty", confirmed_at: "2021-02-20 09:17:54", confirmation_sent_at: "2021-02-20 09:17:44", first_name: "Tony", last_name: "Megalo", phone: "+32484789548", post_code: "1205", address: "Boulevard Carl-Vogt 21", lat: 46.1999, lng: 6.13279, country: "Suisse", completed: true},
    {id: 104, email: "myriam@gmail.com", password: "azerty", confirmed_at: "2021-02-20 09:17:54", confirmation_sent_at: "2021-02-20 09:17:44", first_name: "Myriam", last_name: "Malaimée", phone: "+32484789549", post_code: "1205", address: "Boulevard du Pont-d'Arve 40", lat: 46.1947, lng: 6.14035, country: "Suisse", completed: true},
    {id: 105, email: "coralie@gmail.com", password: "azerty", confirmed_at: "2021-02-20 09:17:54", confirmation_sent_at: "2021-02-20 09:17:44", first_name: "Coralie", last_name: "Dupuis", phone: "+32484789550", post_code: "1201", address: "Rue des Gares 16", lat: 46.2129, lng: 6.14191, country: "Suisse", completed: true},
    {id: 106, email: "julie@gmail.com", password: "azerty", confirmed_at: "2021-02-20 09:17:54", confirmation_sent_at: "2021-02-20 09:17:44", first_name: "Julie", last_name: "Van Delbossche", phone: "+32484789551", post_code: "1227", address: " Route des Acacias 8", lat: 46.1919, lng: 6.13756, country: "Suisse", completed: true}
  ])
  HelpRequest.create!([
    {id: 101, title: "Tyre of my car", created_at: "2021-02-24 09:17:54", description: "I believe everything is in the title, can you help me with that?\nThe car is right in front of my house, its a Honda.\n\nThanks, Jo!", address: "Rue du Mont-Blanc 18, 1201 Suisse", lat: 46.2085, lng: 6.14531, status: "fulfilled", help_type: "immaterial", help_count: 1},
    {id: 102, title: "Heavy truck to unload", created_at: "2021-02-23 09:17:54", description: "Little help would be much appreciated because I have heavy furniture to unload whenever possible.\n\nThanks, Jo!", address: "Rue du Mont-Blanc 40, 1201 Suisse", lat: 46.2092, lng: 6.14306, status: "published", help_type: "material", help_count: 0},
    {id: 103, title: "Could you lend me a bbq?", created_at: "2021-02-22 09:17:54", description: "I plan to organize a BBQ next week at my friend's house.\nWould anyone help with that?\n\nThanks, Jo!", address: "Rue du Mont-Blanc 112, 1201 Suisse", lat: 46.2092, lng: 6.14306, status: "pending", pending_at: "2021-02-25 09:17:44", help_type: "material", help_count: 5},
    {id: 104, title: "Old man needs help for his lawn", created_at: "2021-02-24 09:17:54", description: "Hello dear friends,\n\nCould anyone help me with my lawn? I can't handle the grass anymore.\n\nF.", address: "Rue du Vieux-Collège 3, 1204 Suisse", lat: 46.2019, lng: 6.15044, status: "cancelled", help_type: "immaterial", help_count: 1},
    {id: 105, title: "Garage to clean up", created_at: "2021-02-25 09:17:54", description: "Hey, its Frank again!\n\nMy granddaughter left me with a heavy washing machine in my garage? Can you help me remove it?\nYou can take it home if you want.\n\nThanks,\nF.", address: "Rue du Vieux-Collège 12, 1204 Suisse", lat: 46.2014, lng: 6.1514, status: "published", help_type: "immaterial", help_count: 4},
    {id: 106, title: "Visitors are coming soon - do you have a table (outside) that you could rent?", created_at: "2021-02-25 09:17:54", description: "Hello community,\n\nI am hosting a tea party end of this month. The event will take place outside and I miss a table to serve food for my 20+ guests.\nCan anyone help?\n\nToto le zéro", address: "Boulevard Carl-Vogt 21, 1205 Suisse", lat: 46.1999, lng: 6.13279, status: "published", help_type: "material", help_count: 0},
    {id: 107, title: "My window is too high - need help and/or a huge ladder", created_at: "2021-02-26 09:17:54", description: "Hello,\n\nCan anyone help with that?\n\nThank you!!!!", address: "Boulevard du Pont-d'Arve 40, 1205 Suisse", lat: 46.1947, lng: 6.14035, status: "published", help_type: "immaterial", help_count: 0},
    {id: 108, title: "I don't understand Math", created_at: "2021-02-24 09:17:54", description: "Hi fellows,\n\nWe recently started trigonometry at school and I don't understand shit.\nCan one of you neighbor help me?\n\nYayyy! \n\nThanks, Co.", address: "Rue des Gares 16, 1201 Suisse", lat: 46.2129, lng: 6.14191, status: "published", help_type: "immaterial", help_count: 4}
  ])
  UserHelpRequest.create!([
    {user_id: 101, help_request_id: 101, user_type: "owner"},
    {user_id: 101, help_request_id: 102, user_type: "owner"},
    {user_id: 101, help_request_id: 103, user_type: "owner"},
    {user_id: 102, help_request_id: 104, user_type: "owner"},
    {user_id: 102, help_request_id: 105, user_type: "owner"},
    {user_id: 102, help_request_id: 103, user_type: "respondent"},
    {user_id: 102, help_request_id: 108, user_type: "respondent"},
    {user_id: 103, help_request_id: 104, user_type: "respondent"},
    {user_id: 103, help_request_id: 105, user_type: "respondent"},
    {user_id: 103, help_request_id: 103, user_type: "respondent"},
    {user_id: 103, help_request_id: 101, user_type: "respondent"},
    {user_id: 103, help_request_id: 106, user_type: "owner"},
    {user_id: 104, help_request_id: 107, user_type: "owner"},
    {user_id: 104, help_request_id: 105, user_type: "respondent"},
    {user_id: 104, help_request_id: 103, user_type: "respondent"},
    {user_id: 104, help_request_id: 104, user_type: "respondent"},
    {user_id: 104, help_request_id: 108, user_type: "respondent"},
    {user_id: 105, help_request_id: 108, user_type: "owner"},
    {user_id: 105, help_request_id: 105, user_type: "respondent"},
    {user_id: 105, help_request_id: 103, user_type: "respondent"},
    {user_id: 106, help_request_id: 108, user_type: "respondent"},
    {user_id: 106, help_request_id: 105, user_type: "respondent"},
    {user_id: 106, help_request_id: 103, user_type: "respondent"},
    {user_id: 101, help_request_id: 108, user_type: "respondent"},
  ])
  Conversation.create!([
    {id: 101, help_request_id: 103, owner_user_id: 101, respondent_user_id: 102},
    {id: 102, help_request_id: 101, owner_user_id: 101, respondent_user_id: 103}
  ])
  Message.create!([
    {id: 101, message: "Hi Joe, I have a BBQ you can pick it up at my place. Let me know. F.", conversation_id: 101, user_id: 102, status: "read"},
    {id: 102, message: "Hi Joe, I am mechanical engineer I can help with your tyre. I also have the tools.", conversation_id: 102, user_id: 103, status: "read"},
    {id: 103, message: "That would be great!", conversation_id: 102, user_id: 101, status: "unread"},
    {id: 104, message: "Awesome, I'll contact you again soon.", conversation_id: 101, user_id: 101, status: "read"},
    {id: 105, message: "Thanks for your help btw, I mark the request as fulfilled.", conversation_id: 102, user_id: 101, status: "unread"}
  ])
  ActiveStorage::Blob.create!([
    {id:101, key: "1di1z2xcl7irocf2byh94yptlu6p", filename: "512.jpg", content_type: "image/jpeg", metadata: {"identified"=>true, "analyzed"=>true}, byte_size: 28841, checksum: "hpf5CMiK78aDB5opCmhSxg=="}
  ])
  ActiveStorage::Attachment.create!([
    {id: 101, name: "gov_id", record_type: "User", record_id: 101, blob_id: 101},
    {id: 102, name: "gov_id", record_type: "User", record_id: 102, blob_id: 101},
    {id: 103, name: "gov_id", record_type: "User", record_id: 103, blob_id: 101},
    {id: 104, name: "gov_id", record_type: "User", record_id: 104, blob_id: 101},
    {id: 105, name: "gov_id", record_type: "User", record_id: 105, blob_id: 101},
    {id: 106, name: "gov_id", record_type: "User", record_id: 106, blob_id: 101},
  ])
end

if Rails.env.test? && User.count.zero?
  # Used for Channels - rspec
  owner_user = User.create(email: "owner_user_seed@test.com", password: "azerty", completed: true, confirmed_at: DateTime.current)
  respondent_user = User.create(email: "respondent_user_seed@test.com", password: "azerty", completed: true, confirmed_at: DateTime.current)
  second_respondent_user = User.create(email: "respondent2_user_seed@test.com", password: "azerty", completed: true, confirmed_at: DateTime.current)
  User.create(email: "unrelated_user_seed@test.com", password: "azerty", completed: true, confirmed_at: DateTime.current)
  help_request = HelpRequest.create(title: "Test seed title", description: "Test seed description", address: "Test seed address", lat: 0.0, lng: 0.0, status: "published", :help_type => "material", :help_count => 1)
  help_request.user_help_requests.create(user_id: owner_user.id, user_type: "owner")
  help_request.user_help_requests.create(user_id: respondent_user.id, user_type: "respondent")
  help_request.user_help_requests.create(user_id: second_respondent_user.id, user_type: "respondent")
  conversation = help_request.conversations.create(owner_user_id: owner_user.id, respondent_user_id: respondent_user.id)
  conversation.messages.create(:user_id => owner_user.id, :message => "Hello dude!")
  # User for Controllers - rspec
  User.create(email: "profile_user_seed@test.com", password: "azerty", completed: true, confirmed_at: DateTime.current)
end
