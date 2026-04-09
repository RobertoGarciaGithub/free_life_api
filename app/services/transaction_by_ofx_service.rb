class TransactionByOfxService
  def self.call(arr, user, account)
    new(arr, user, account).call
  end

  def initialize(arr, user, account)
    @arr = arr
    @user = user
    @account = account
  end

  def call
    @arr.map do |t|
      transaction = Transaction.find_by(fitid: t[:fitid])
      next if transaction.present?

      Transaction.create(
        fitid: t[:fitid],
        user_id: @user.id,
        transactable: @account,
        amount_cents: t[:amount_cents],
        description: t[:description]
      )
    end
  end
end
