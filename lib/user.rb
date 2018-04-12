require 'openssl'
require 'transaction'

class User

  attr_reader :name, :public_key

  def initialize(name)
    @name = name
    rsa = OpenSSL::PKey::RSA.new(2_048)
    @private_key = rsa.export
    @public_key = rsa.public_key.export
  end

  def transfer(to:, amount:)
    Transaction.new(
      from: @public_key,
      to: to,
      amount: amount,
      private_key: @private_key
    )
  end

end
