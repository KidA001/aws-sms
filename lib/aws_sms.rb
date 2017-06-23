require "aws_sms/version"
require 'aws-sdk'
require 'configatron'
require 'aws_sms/config'

class AwsSms
  class SNSClientError < StandardError; end
  class InvalidNumber < StandardError; end

  def initialize(region: nil, access_key_id: nil, secret_key: nil,
                 default_sms_type: 'Transactional', default_sender_id: '')
    @region            = region            || Config.region
    @access_key_id     = access_key_id     || Config.access_key
    @secret_key        = secret_key        || Config.secret_key
    @default_sms_type  = default_sms_type  || Config.sms_type
    @default_sender_id = default_sender_id || Config.default_sender_id
  end

  def send(phone_number, message)
    validate_args!
    set_config!
    client.publish(phone_number: phone_number, message: message)
  end

  private
  attr_reader :region, :access_key_id, :secret_key, :default_sender_id,
              :default_sms_type

  def client
    sns = ::Aws::SNS::Client.new()
    sns.set_sms_attributes({ attributes: {
      "DefaultSMSType" => default_sms_type,
      "DefaultSenderID" => default_sender_id
    }})
    sns
  end

  def set_config!
    ::Aws.config.update({
      region: region,
      credentials: Aws::Credentials.new(access_key_id, secret_key)
    })
  end

  def validate_args!
    if region.nil? || access_key_id.nil? || secret_key.nil?
      message = 'ERROR: region, access_key_id, and secret_key arguments must '\
              'be provided. You can explicitly set them when initializing '\
              'AwsSms, set them in your Environment Variables as: '\
              'AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, '\
              'or use AwsSms::Config.set_credentials'
      raise ArgumentError, message
    end
  end
end