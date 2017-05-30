ActionMailer::Base.smtp_settings = {
    address: ENV['BTE_SMTP_ADDRESS'],
    domain: ENV['BTE_SMTP_DOMAIN'],
    user_name: ENV['BTE_SMTP_USERNAME'],
    password: ENV['BTE_SMTP_PASSWORD'],
    :port => 25,
    :authentication => :plain,
    :enable_starttls_auto => true
}