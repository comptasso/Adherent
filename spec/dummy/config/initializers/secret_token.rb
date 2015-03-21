# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# Dummy::Application.config.secret_token = '891fd10ca76294dc2eba56dad2e80aa8a28a49634b6b7fe4e3d470cb26affc02346bcae23f9cf667df45360f98de9b7e134208a485fb7f3592ac44cdd0d45d36'
require 'securerandom'

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

def find_secure_token
  token_file = Rails.root.join('.secret')
  if File.exist? token_file
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token of 64 random hexadecimal characters and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

Dummy::Application.config.secret_key_base = find_secure_token