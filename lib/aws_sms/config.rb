require 'configatron'

class AwsSms
  module Config

    def self.set_credentials(aws_default_region:, aws_access_key_id: , aws_secret_access_key:)
      configatron.aws_default_region = aws_default_region
      configatron.aws_access_key_id = aws_access_key_id
      configatron.aws_secret_access_key = aws_secret_access_key
    end

    def self.set_sms_attributes(attributes)
      configatron.sms_attributes = attributes
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

    def self.sms_attributes
      unless configatron.has_key?(:sms_attributes)
        configatron.sms_attributes = { 'DefaultSMSType' => 'Transactional' }
      end
      configatron.sms_attributes
    end
  end
end
