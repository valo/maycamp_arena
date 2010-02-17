# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_students_session',
  :secret      => '6dbcac98d6a4918b34bf69741e2182d157d295ecc24d608bfebc69e96583e2dd0cb27b47c58f3362ef4091f29a36be9c2f1ef80d04384c470b05cf0b2ada8534'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
