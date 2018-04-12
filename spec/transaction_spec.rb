require 'transaction'

RSpec.describe Transaction do

  let(:emitter_rsa)          { OpenSSL::PKey::RSA.new(2_048) }
  let(:emitter_public_key)   { emitter_rsa.public_key.export }
  let(:emitter_private_key)  { emitter_rsa.export }
  let(:recipient_rsa)        { OpenSSL::PKey::RSA.new(2_048) }
  let(:recipient_public_key) { recipient_rsa.public_key.export }
  let(:transaction)          {
    Transaction.new(
      from: emitter_public_key,
      to: recipient_public_key,
      amount: 12.34,
      private_key: emitter_private_key
    )
  }

  describe "#initialize" do


    it "stores the public keys" do
      expect(transaction.from).to eq(emitter_public_key)
      expect(transaction.to).to eq(recipient_public_key)
    end

    it "signs the transaction" do
      expect(transaction.signature).to_not be_nil
    end

    it "adds a timestamp" do
      expect(transaction.timestamp).to be_within(1_000).of(Time.now.to_f * 1_000)
    end

  end

  describe "#message" do

    it "is a SHA-256 hexa digest of transaction's information" do
      expect(transaction.message).to match(/^[0-9a-f]{64}$/)
    end

  end

  describe "#valid?" do

    context "the emitter public key has been corrupted" do

      it "is false" do
        allow(transaction).to receive(:from).and_return(recipient_public_key)
        expect(transaction).to_not be_valid
      end

    end

    context "the message has changed" do

      it "is false" do
        allow(transaction).to receive(:message).and_return(transaction.message.split('').shuffle.join)
        expect(transaction).to_not be_valid
      end

    end

    context "the emitter public key has not changed" do

      it "is true" do
        expect(transaction).to be_valid
      end

    end

  end

end
