module AWS
  def self.config(region: ENV['aws_region'],
                  aws_access_key_id: ENV['aws_access_key_id'],
                  aws_secret_key: ENV['aws_access_key_id'])

    Aws.config.update({
      region: region, credentials: Aws::Credentials.new(
        aws_access_key_id, aws_secret_key
      )
    })
  end
end
