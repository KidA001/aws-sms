# AwsSms

This gem acts as a simple wrapper for sending SMS Messages with Amazon SNS. It's as easy as adding your AWS Credentials and calling `AwsSms.new.send(phone_number, message)`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_sms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_sms

## Usage
You must have an AWS Account Setup with SMS Enabled under your Simple Notification Service. You will need IAM Credentials that have `AmazonSNSFullAccess` permissions. Details below on how to load your credentials.

You must follow Amazon's requirements on sending text messages, for instance, you must provide a country code for the phone number you provide (e.g. `12225675309` where `1` is the country code) You can check [Amazon's Documentation](http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Errors.html) for details on any errors that are raised.

### AWS Credentials

There are three ways to load your AWS Credentials:

You can initialzie `AwsSms` with your credentials as arguments:
```ruby
sms = AwsSms.new(
  aws_default_region: 'us-west 2',
  aws_access_key_id: 'your access key',
  aws_secret_access_key: 'your secret key'
)
sms.send('15555555555', 'Some great message')
```


Set them through the config object. If you're using Rails you can store this in an initializer
```ruby
# config/initializers/aws_sms.rb
AwsSms::Config.set_credentials(
  aws_default_region: 'us-west 2',
  aws_access_key_id: ACCESS_KEY,
  aws_secret_access_key: SECRET_KEY
)
...
# somewhere in your application
sms = AwsSms.new
sms.send('15555555555', 'Hello!')
```


Or you can securely store the credentials in your environment variables. This gem will search for them as follows:
```bash
# .env
AWS_ACCESS_KEY_ID=123456
AWS_SECRET_ACCESS_KEY=abc123foobarbaz
AWS_DEFAULT_REGION=us-east-2
...
```
```ruby
# somewhere in your application

sms = AwsSms.new
sms.send('15555555555', 'Foo bar baz!')
```
### AWS SMS Attributes
You can provide Amazon SMS Attributes in a similar way. Attributes default to `{ 'DefaultSMSType' => 'Transactional' }` if none are provided. See Amazon's Documentation on [SMS Attributes](http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html#set_sms_attributes-instance_method) to see what options are available to pass
```ruby
attributes = { 
  'DefaultSenderID' => 'SomeSenderId', 'DefaultSMSType' => 'Promotional' 
}
sms = AwsSms.new(sms_attributes: attributes)
sms.send(...)
```
or
```ruby
AwsSms::Config.set_sms_attributes(
  { 'MonthlySpendLimit' => '1000', 'DefaultSMSType' => 'Promotional' }
)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KidA001/aws_sms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

