require "aws_sms/version"
require 'aws-sdk'

class AwsSms
  class SNSClientError < StandardError; end
  class InvalidNumber < StandardError; end

  def initialize(region: nil, access_key_id: nil, secret_key: nil,
                 default_sms_type: 'Transactional', default_sender_id: '')
    @region            = region        || ENV['AWS_DEFAULT_REGION']
    @access_key_id     = access_key_id || ENV['AWS_ACCESS_KEY_ID']
    @secret_key        = @secret_key   || ENV['AWS_SECRET_ACCESS_KEY']
    @default_sms_type  = default_sms_type
    @default_sender_id = default_sender_id
  end

  def send(phone_number, message)
    validate_args!

    client.publish(phone_number: phone_number, message: message)
  rescue ::Aws::SNS::Errors::InvalidParameter => e
    raise InvalidNumber, 'Invalid phone number'
  rescue ::Aws::SNS::Errors::ServiceError => e
    raise SNSClientError, e.message
  end

  private
  attr_reader :region, :access_key_id, :secret_key, :default_sender_id,
              :default_sms_type

  def client
    sns = ::Aws::SNS::Client.new()
    sns.set_sms_attributes({
      attributes: {
        "DefaultSMSType" => default_sms_type,
        "DefaultSenderID" => default_sender_id
      }
    })
    sns
  end

  def validate_args!
    if region.nil? || access_key_id.nil? || secret_key.nil?
      message = 'region, access_key_id, and secret_key arguments must be '\
              'provided. You can explicitly set them when initializing '\
              'AWS::SMS.new or set them in your Environment Variables as: '\
              'AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY'
      raise ArgumentError, message
    end
  end
end
