Rails.application.configure do
    config.google_sign_in.client_id     = ENV['HELPEXCHANGE_GOOGLE_SSO_ID']
    config.google_sign_in.client_secret = ENV['HELPEXCHANGE_GOOGLE_SSO_SECRET']
end