require 'user'

RSpec.describe User do

  let(:albert) { User.new("Albert") }

  describe "#initialize" do

    it "generates a key pair" do
      expect(albert.public_key).to_not be_nil
    end

    it "stores the name" do
      expect(albert.name).to eq("Albert")
    end

  end

  describe "#transfer" do

    let(:basile) { User.new("Basile") }
    let(:transaction) { albert.transfer to: basile.public_key, amount: 12.34 }

    it "initializes a new transaction" do
      expect(transaction).to be_a(Transaction)
      expect(transaction.from).to eq(albert.public_key)
      expect(transaction.to).to eq(basile.public_key)
    end

  end

end
