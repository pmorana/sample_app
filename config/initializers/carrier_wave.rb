if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAJBZEBNNMV7GYWT4Q'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['xlo250rails']
  end
end