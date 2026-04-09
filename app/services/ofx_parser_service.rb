class OfxParserService
  def self.call(file)
    new(file).call
  end

  def initialize(file)
    @file = file
  end

  def call
    ofx = OFX(content)

    ofx.account.transactions.map do |t|
      {
        fitid: t.fit_id,
        date: t.posted_at.to_date,
        amount_cents: t.amount_in_pennies.to_i,
        description: (t.memo.presence || t.name).to_s.strip
      }
    end
  rescue OFX::UnsupportedFileError => e
    raise OFX::UnsupportedFileError, e.message
  end

  private

  def content
    @content ||= @file.respond_to?(:read) ? @file.read : File.read(@file)
  end
end
