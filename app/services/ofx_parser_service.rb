class OfxParserService
  def self.call(file)
    new(file).call
  end

  def initialize(file)
    @file = file
  end

  def call
    ofx = OFX(content)
    account = ofx.account

    {
      account: parse_account(account),
      transactions: parse_transactions(account.transactions)
    }
  rescue OFX::UnsupportedFileError => e
    raise OFX::UnsupportedFileError, e.message
  end

  private

  def parse_account(account)
    {
      bank_id: account.bank_id,
      account_id: account.id,
      account_type: account.type,
      currency: account.currency,
      balance: {
        amount_cents: to_cents(account.balance.amount),
        as_of: account.balance.posted_at&.to_date
      },
      statement_period: {
        started_at: account.transactions.map(&:posted_at).min&.to_date,
        ended_at: account.transactions.map(&:posted_at).max&.to_date
      }
    }
  end

  def parse_transactions(transactions)
    transactions.map { |t| parse_transaction(t) }
  end

  def parse_transaction(t)
    {
      fitid: t.fit_id,
      type: t.type,
      date: t.posted_at&.to_date,
      amount_cents: to_cents(t.amount),
      name: t.name.to_s.strip.presence,
      description: (t.memo.presence || t.name).to_s.strip.presence,
      check_number: t.check_number.presence,
      sic: t.sic.presence
    }.compact
  end

  def to_cents(amount)
    return 0 if amount.nil?

    (amount * 100).round
  end

  def content
    @content ||= @file.respond_to?(:read) ? @file.read : File.read(@file)
  end
end
