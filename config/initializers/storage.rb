CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV["AWS_ID"],
      aws_secret_access_key: ENV["AWS_SECRET"],
      region: 'ca-central-1'
  }
  config.fog_directory  = "volo-avatar"
  config.fog_public     = false
end
