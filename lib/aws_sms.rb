require 'aws_sms/version'
require 'aws-sdk'
require 'aws_sms/config'

class AwsSms
  class SNSClientError < StandardError; end
  class InvalidNumber < StandardError; end
  attr_reader :client

  def initialize(aws_default_region: nil, aws_access_key_id: nil,
                 aws_secret_access_key: nil, sms_attributes: nil)

    @aws_default_region    = aws_default_region    || Config.region
    @aws_access_key_id     = aws_access_key_id     || Config.access_key
    @aws_secret_access_key = aws_secret_access_key || Config.secret_key
    @sms_attributes        = sms_attributes        || Config.sms_attributes
    validate_args!
    set_config!
  end

  def send(phone_number, message)
    client.publish(phone_number: phone_number, message: message)
  end

  def client
    @client ||= begin
      sns = ::Aws::SNS::Client.new()
      sns.set_sms_attributes({ attributes: sms_attributes })
      sns
    end
  end

  private
  attr_reader :aws_default_region, :aws_access_key_id, :aws_secret_access_key,
              :sms_attributes

  def set_config!
    ::Aws.config.update({
      aws_default_region: aws_default_region,
      credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key)
    })
  end

  def validate_args!
    if aws_default_region.nil? || aws_access_key_id.nil? || aws_secret_access_key.nil?
      message = 'ERROR: aws_default_region, aws_access_key_id, and '\
                'aws_secret_access_key arguments must be provided. You can '\
                'explicitly set them when initializing AwsSms, set them in '\
                'your Environment Variables as: AWS_DEFAULT_REGION, '\
                'AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or use '\
                'AwsSms::Config.set_credentials'
      raise ArgumentError, message
    end
  end
end
