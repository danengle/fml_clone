# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_fml_clone_session',
  :secret => '432a39d2f73a3b92efa758d0455c21b07522586d7901e330570390ddf007ea0b33b6e4179f5f3bd3b3a58682d5b9414dcb01d648b279a111560be00095dcd04e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
