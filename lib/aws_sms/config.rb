require 'configatron'

class AwsSms
  module Config

    def self.set_credentials(aws_default_region:, aws_access_key_id: , aws_secret_access_key:)
      configatron.aws_default_region = aws_default_region
      configatron.aws_access_key_id = aws_access_key_id
      configatron.aws_secret_access_key = aws_secret_access_key
    end

    def self.set_sms_defaults(default_sms_type: nil, default_sender_id: nil)
      configatron.default_sms_type = default_sms_type
      configatron.default_sender_id = default_sender_id
    end

    def self.access_key
      ENV['AWS_ACCESS_KEY_ID']     || configatron.aws_access_key_id
    end

    def self.region
      ENV['AWS_DEFAULT_REGION']    || configatron.aws_default_region
    end

    def self.secret_key
      ENV['AWS_SECRET_ACCESS_KEY'] || configatron.aws_secret_access_key
    end

    def self.sms_type
      configatron.default_sms_type
    end

    def self.default_sender_id
      configatron.default_sender_id
    end
  end
end
