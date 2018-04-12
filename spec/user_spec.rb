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

    it "credits the user by default" do
      skip "Question 4 : supprimer cette ligne pour exécuter ce test"
      expect(albert.balance).to eq(100.0)
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

    it "debits the user" do
      skip "Question 6 : supprimer cette ligne pour exécuter ce test"
      expect do
        transaction
      end.to change(albert, :balance).by(-12.34)
    end

    context "unsufficient balance" do

      let(:cecile) { User.new "Cécile", 10.0 }
      let(:transaction) { cecile.transfer to: basile.public_key, amount: 12.0 }

      it "is nil" do
        skip "Question 5 : supprimer cette ligne pour exécuter ce test"
        expect(transaction).to be_nil
      end

      it "doesn't debit the user" do
        skip "Question 5 : supprimer cette ligne pour exécuter ce test"
        expect do
          transaction
        end.to_not change(cecile, :balance)
      end

    end

    context "same user" do

      let(:transaction) { albert.transfer to: albert.public_key, amount: 12.34 }

      it "is nil" do
        skip "Question 7 : supprimer cette ligne pour exécuter ce test"
        expect(transaction).to be_nil
      end

      it "doesn't debit the user" do
        skip "Question 7 : supprimer cette ligne pour exécuter ce test"
        expect do
          transaction
        end.to_not change(albert, :balance)
      end

    end

  end

end
