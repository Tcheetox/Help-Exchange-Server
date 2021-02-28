class DeviseMailer < Devise::Mailer
    default "Message-ID" => lambda {"<#{SecureRandom.uuid}@#{ENV['HELPEXCHANGE_MAILER_DOMAIN']}>"}
    ## ...
  end
  