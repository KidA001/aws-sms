require 'spec_helper'

describe AwsSms do
  let(:kwargs) { {} }
  let(:sns_client) { double('SNS Client', set_sms_attributes: nil) }
  let(:subject) { described_class.new(**kwargs) }
  before { allow(Aws::SNS::Client).to receive(:new).and_return(sns_client) }

  describe 'Aws Config' do
    let(:config) { double('aws-config')}
    before { allow(::Aws).to receive(:config).and_return(config) }

    context 'When config is provided in the arguments' do
      let(:kwargs) do
        {
          aws_default_region: 'us-west-2',
          aws_access_key_id: 'abc123',
          aws_secret_access_key: 'foobar'
        }
      end

      it 'uses the provided config' do
        expect(config).to receive(:update).with({
          aws_default_region: 'us-west-2',
          credentials: anything
        })
        expect(Aws::Credentials).to receive(:new).with('abc123', 'foobar')
        subject
      end
    end

    context 'When no config is provided' do
      before do
        AwsSms::Config.set_credentials(
          aws_default_region: 'us-east-2',
          aws_access_key_id: '1234',
          aws_secret_access_key: 'foobarbaz'
        )
      end

      it 'uses attributes set in AwsSms::Config' do
        expect(config).to receive(:update).with({
          aws_default_region: AwsSms::Config.region,
          credentials: anything
        })
        expect(Aws::Credentials).to receive(:new).with(
          AwsSms::Config.access_key,
          AwsSms::Config.secret_key
        )
        subject
      end
    end
  end

  describe '#send' do
    let(:phone_number) { '+15555555555' }
    let(:message) { 'O hai' }

    it 'calls publish on the client with correct arguments' do
      expect(sns_client).to(
        receive(:publish).
        with(phone_number: phone_number, message: message)
      )
      subject.send(phone_number, message)
    end
  end

  describe '#client' do
    let(:client) { subject.client }

    it 'is returns a AWS::SNS::Client' do
      expect(client).to eq(sns_client)
    end

    context 'when sms attributes are provided' do
      let(:kwargs) { { sms_attributes: { "DefaultSenderID" => 'SenderID' } } }

      it 'uses the provided attributes' do
        expect(sns_client).to(
          receive(:set_sms_attributes).
          with({ attributes: { "DefaultSenderID" => "SenderID" } })
        )
        client
      end
    end

    context 'when no sms attributes are provided' do
      it 'uses attributes set in AwsSms::Config' do
        expect(sns_client).to(
          receive(:set_sms_attributes).
          with({ attributes: AwsSms::Config.sms_attributes })
        )
        client
      end
    end
  end
end
