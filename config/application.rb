require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Publify
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end

  # Load included libraries.
  require 'publify_sidebar'
  require 'publify_textfilters'
  require 'publify_avatar_gravatar'
  require 'publify_version'

  Theme.register_themes "#{Rails.root}/themes"

  Date::DATE_FORMATS.merge!(
    :long_weekday => '%a %B %e, %Y %H:%M'
  )

  # TimeZone
  if  File.file? "#{::Rails.root.to_s}/config/timezone.yml"
    Time.zone = YAML.load(File.read("#{::Rails.root.to_s}/config/timezone.yml"))
  end

  ActionMailer::Base.default :charset => 'utf-8'

  if ::Rails.env != 'test'
    begin
      mail_settings = YAML.load(File.read("#{::Rails.root.to_s}/config/mail.yml"))

      %w(delivery_method smtp_settings sendmail_settings file_settings).each do |key|
        ActionMailer::Base.send "#{key}=", mail_settings[key]
      end
    rescue
      # Fall back to using sendmail by default
      ActionMailer::Base.delivery_method = :sendmail
    end
  end
end
