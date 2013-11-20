# cant_wait ~ Gem Signature verification
[![Gem Version](https://badge.fury.io/rb/cant_wait.png)](https://badge.fury.io/rb/cant_wait)
[![Dependency Status](https://gemnasium.com/CarlosCD/cant_wait.png)](https://gemnasium.com/CarlosCD/cant_wait)


All the versions of **cant_wait** released from rubygems.org have been digitally signed.

To verify that the gem has not been tampered with, I am providing here the self-signed certificate used, which includes the public key.

Therefore, you have now two pieces of information from two different sources:

- The signed gem from [RubyGems.org](http://rubygems.org/gems/cant_wait)
- The certificate from [Github.com's](https://github.com/CarlosCD/cant_wait) repository

This mechanism is far from perfect, but I believe it is better than no security at all, until the Ruby community and RuybyGems.org agrees in something better (and free).


## Cryptographic signature verification

To verify the gem's signature:

1. First install the certificate public_cert.pem downloaded from the cert folder of Github's repository (master branch):

        gem cert -a public_cert.pem

2. Then Download the last version of the gem (or a version you intend to use) from rubygems.org.  The file would look something like:

        cant_wait-X.Y.Z.gem

   Where <tt>X.Y.Z</tt> is the gem's version.

3. Next the gem can be installed with the high security option, which checks that the gem is signed and the signature matches an installed certificate:

        gem install cant_wait-X.Y.Z.gem -P HighSecurity

If the certificate or the gem has been tampered with, the gem command (RubyGems) should refuse to install it.


## On certificate renewal and expiration

The certificate used to sign **cant_wait** versions 0.0.1 to 0.0.3 had a short validity time, so the one provided in the cert folder in Github is a renewal of the original, with a longer expiration date. I've used this certificate from versions 0.0.4 and on.  However, the verification process explained above won't complain, as both certificates use the same cryptographic keys and same identity data.

The reason for this notice is that other verification systems may say that the certificate doesn't match for early version of the gem, even if the public key is the same.


## Use of Bundler to install signed and trusted gems, or not

The usual way to install gem dependencies using bundler, as it is commonly done in Rails, is by executing the command:

    bundler

or

    bundler install

If used this way, unless additional parameters are added by your particular setup (maybe using bundle's config), bundler doesn't verify gem signatures.  If this is a concern to you, then you should:

1. Install the certificates of the gems you know and trust, as explained above (<tt>gem cert -a certificate</tt>).
2. Bundle install with the <tt>High security</tt> option:

        bundle --trust-policy HighSecurity

    or

        bundle install --trust-policy HighSecurity

Please be aware that the practice of signing gems is not followed as a standard by the whole development community, so you may find that many of the most popular ruby gems are not signed (bundler and rails are not signed at this moment).  Therefore you may need to think about it, compromise, or carefully audit the code of the gems you try to install.


November 2013
