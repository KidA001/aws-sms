require 'spec_helper'

describe AwsSms::Config do
  let(:subject) { described_class }

  describe '#set_credentials' do
    let(:region) { 'us-west-2' }
    let(:access_key) { 'abc123' }
    let(:secret_key ) { 'foobar' }

    it 'stores the values with configatron' do
      subject.set_credentials(
        aws_default_region: region,
        aws_access_key_id: access_key,
        aws_secret_access_key: secret_key
      )
      expect(configatron.aws_default_region).to eq(region)
      expect(configatron.aws_access_key_id).to eq(access_key)
      expect(configatron.aws_secret_access_key).to eq(secret_key)
    end
  end

  describe '#set_sms_attributes' do
    let(:attributes) { { 'MonthlySpendLimit' => '1000' } }

    it 'stores the values with configatron' do
      subject.set_sms_attributes(attributes)
      expect(configatron.sms_attributes).to eq(attributes)
    end
  end

  describe '#access_key' do
    let(:access_key) { 'abc123' }

    it 'returns the value set in configatron' do
      configatron.aws_access_key_id = access_key
      expect(subject.access_key).to eq(access_key)
    end

    context 'when the ENV is set' do
      before { ENV["AWS_ACCESS_KEY_ID"] = 'abc1234' }

      it 'returns the ENV value' do
        expect(subject.access_key).to eq('abc1234')
      end
    end
  end
  
  describe '#region' do
    let(:region) { 'us-west-2' }

    it 'returns the value set in configatron' do
      configatron.region = region
      expect(subject.region).to eq(region)
    end

    context 'when the ENV is set' do
      before { ENV["AWS_DEFAULT_REGION"] = 'us-east-2' }

      it 'returns the ENV value' do
        expect(subject.region).to eq('us-east-2')
      end
    end
  end

  describe '#secret_key' do
    let(:secret_key) { 'foobar' }

    it 'returns the value set in configatron' do
      configatron.aws_secret_access_key = secret_key
      expect(subject.secret_key).to eq(secret_key)
    end

    context 'when the ENV is set' do
      before { ENV["AWS_SECRET_ACCESS_KEY"] = 'foobarbaz' }

      it 'returns the ENV value' do
        expect(subject.secret_key).to eq('foobarbaz')
      end
    end
  end

  describe '#sms_attributes' do
    let(:attributes) { { 'DefaultSMSType' => 'Promotional' } }

    it 'returns the value set in configatron' do
      configatron.sms_attributes = attributes
      expect(subject.sms_attributes).to eq(attributes)
    end

    context 'when no value has been set' do
      before { configatron.reset! }

      it 'returns the default value' do
        expect(subject.sms_attributes).to eq(
          { 'DefaultSMSType' => 'Transactional' }
        )
      end
    end
  end
end
