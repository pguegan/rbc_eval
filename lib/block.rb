class Block

  attr_reader :own_hash

  def initialize(previous_hash: nil, transaction:)
    @previous_hash = previous_hash
    @transaction = transaction
    @own_hash = ""
    @nonce = nil
  end

  # Cherche un +nonce+ par brute force jusqu'à ce que le hash du bloc
  # commence par un certain nombre de zéros. Ceci prouve alors le
  # travail de minage du bloc.
  def mine!
    @nonce = "aaaaaaaa"
    until @own_hash.start_with?("0000")
      @own_hash = Digest::SHA256.hexdigest(message + @nonce)
      @nonce.next!
    end
  end

  # Représentation synthétique et caractéristique du bloc, basée sur :
  # - le message (contenu) de la transaction
  # - le hash du bloc précédent (s'il existe)
  def message
    Digest::SHA256.hexdigest([@transaction.message, @previous_hash].compact.join)
  end

  def to_s
    [
      "Previous: ".rjust(14) + @previous_hash,
      "Transaction: ".rjust(14) + @transaction.message,
      "Message: ".rjust(14) + message,
      "Nonce: ".rjust(14) + @nonce,
      "Hash: ".rjust(14) + @own_hash
    ].join("\n")
  end

end
