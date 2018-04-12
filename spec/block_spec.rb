require 'block'

RSpec.describe Block do

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
  let(:block) { Block.new(transaction: transaction) }

  describe "#initialize" do

    it "starts with an empty hash" do
      expect(block.own_hash).to eq("")
    end

  end

  describe "#mine!" do

    it "finds a SHA-256 hexa hash digest with 4 trailing zeros" do
      block.mine!
      expect(block.own_hash).to match(/^0{4}[0-9a-f]{60}$/)
    end

  end

end
