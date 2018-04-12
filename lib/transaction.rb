require 'openssl'
require 'base64'

class Transaction

  attr_reader :from, :to, :amount, :timestamp, :signature

  # Créé et signe une nouvelle transaction.
  # Params:
  # +from+:: Clé publique de l'émetteur de la transaction
  # +to+:: Clé publique du récepteur de la transaction
  # +amount+:: Montant de la transaction
  # +private_key+:: Clé privée de l'émetteur, servant à signer la transaction
  def initialize(from:, to:, amount:, private_key:)
    @from = from #
    @to = to
    @amount = amount
    @timestamp = (Time.new.to_f * 1_000).to_i
    sign private_key
  end

  # Indique si la transaction est correctement signée et authentique, en
  # vérifiant que c'est bien la clé privée associée à la clé publique de
  # l'émetteur qui a été utilisée pour signer la transaction.
  def valid?
    rsa = OpenSSL::PKey::RSA.new(from)
    message == rsa.public_decrypt(Base64.decode64 signature)
  rescue OpenSSL::PKey::RSAError
    false
  end

  # Représentation synthétique et caractéristique de la transaction.
  def message
    Digest::SHA256.hexdigest [from, to, amount, timestamp].join
  end

private

  def sign(private_key)
    rsa = OpenSSL::PKey::RSA.new(private_key)
    @signature = Base64.encode64(rsa.private_encrypt message)
  end

end
