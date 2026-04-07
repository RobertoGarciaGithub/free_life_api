if defined?(Money)
  Money.default_currency = Money::Currency.new('BRL')

  Money.locale_backend = :i18n if Money.respond_to?(:locale_backend=)
end

if defined?(MoneyRails)
  MoneyRails.configure do |config|
    config.default_currency = :brl
  end
end
