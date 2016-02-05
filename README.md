##Fix##

Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    /Users/cmthakur/.rvm/rubies/jruby-1.7.11/bin/jruby extconf.rb
OpenSSL::X509::StoreError: setting default path failed: Invalid keystore format
  set_default_paths at org/jruby/ext/openssl/X509Store.java:162

download certfile from
http://curl.haxx.se/ca/cacert.pem

export SSL_CERT_FILE=/usr/lib/ssl/jcert.pem