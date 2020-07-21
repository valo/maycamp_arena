require 'syslog/logger'

MaycampArena::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_mailer.smtp_settings = {
    :port           => 587,
    :address        => 'smtp.mailgun.org',
    :user_name      => 'postmaster@arena.maycamp.com',
    :password       => ENV['MAILGUN_KEY'],
    :domain         => ENV['MAILGUN_DOMAIN'],
    :authentication => :plain,
  }
  config.action_mailer.delivery_method = :smtp

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  config.log_level = :info

  # Use a different logger for distributed setups
  config.logger = Syslog::Logger.new 'maycamp_arena'

  # Use a different cache store in production
  config.cache_store = :dalli_store, (ENV['MEMCACHE_URL'] || 'localhost'), { :pool_size => 8, :threadsafe => true }

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_files = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.assets.compile = false

  config.assets.digest = true
  config.assets.css_compressor = :sass
  config.assets.js_compressor = :uglify

  # Enable threaded mode
  # config.threadsafe!

  # Require HTTPS
  config.force_ssl = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { :host => (ENV["SITE_DOMAIN"] || "arena.maycamp.com") }

  # Active Job config
  config.active_job.queue_adapter = :sidekiq

  # Store files on Amazon S3.
  config.active_storage.service = :amazon
end
