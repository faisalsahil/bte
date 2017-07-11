CarrierWave.configure do |config|
  config.fog_credentials = {
      provider:              'AWS',                                      # required
      aws_access_key_id:     ENV['BTE_AMAZON_KEY_' + ENV['BTE_MODE']],   # required
      aws_secret_access_key: ENV['BTE_AMAZON_SECRET_' + ENV['BTE_MODE']],# required
      region:                'us-east-1',                                # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV['BTE_AMAZON_BUCKET_' + ENV['BTE_MODE']]    # required
end