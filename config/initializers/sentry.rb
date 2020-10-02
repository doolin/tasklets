# frozen-string-literal: true

module Tasklets
  # Custom sanitizer not yet hooked up.
  class SentrySanitizer < Raven::Processor
    def process(data)
      data.tap do |d|
        # do nothing for now
      end
    end
  end
end

# https://sentry.io/dave-doolin/tasklets/getting-started/ruby-rails/
Rails.application.config.before_configuration do
  Raven.configure do |config|
    config.dsn = ENV['RAVEN_TASKLETS_DSN']
    config.environments = %w[development production]
    config.processors << Tasklets::SentrySanitizer
  end
end
