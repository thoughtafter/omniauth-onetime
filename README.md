# OmniAuth One-Time

[![Code Climate](https://codeclimate.com/github/thoughtafter/omniauth-onetime/badges/gpa.svg)](https://codeclimate.com/github/thoughtafter/omniauth-onetime)
[![Test Coverage](https://codeclimate.com/github/thoughtafter/omniauth-onetime/badges/coverage.svg)](https://codeclimate.com/github/thoughtafter/omniauth-onetime/coverage)
[![Issue Count](https://codeclimate.com/github/thoughtafter/omniauth-onetime/badges/issue_count.svg)](https://codeclimate.com/github/thoughtafter/omniauth-onetime)

An [OmniAuth](https://github.com/omniauth/omniauth) strategy using secure
onetime passwords.

I released this code on Dec 14, 2016 after having used it in production for some
time. Coincidentally, this is the same day that
[Yahoo disclosed a breach of 1 billion accounts](https://yahoo.tumblr.com/post/154479236569/important-security-information-for-yahoo-users)
which may have included MD5 hashed passwords. In the wake of this and numerous
other password breaches every web development team needs to ask:

**Is it worth storing long term user generated passwords?**

I suggest that it very rarely is.

## Vision

Strong passwords are difficult to remember. Rememberable passwords are usually
weak. Thus asking users to create and remember strong passwords is a limited
proposition.

The purpose of this gem is to provide a way for developers to quickly add a
secure authentication system to Rack based projects. This system is based on
one-time passwords which are emailed to the user at sign in time. These
passwords quickly expire (5 minute default, expiration time is configurable)
in order to thwart brute-force attacks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-onetime'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-onetime

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/thoughtafter/omniauth-onetime. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

omniauth-onetime is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

omniauth-onetime is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with omniauth-onetime.  If not, see <http://www.gnu.org/licenses/>.

## Details

Reading List:

* 2014-04-12: [Passwords are Obsolete](https://medium.com/@ninjudd/passwords-are-obsolete-9ed56d483eb)
* 2014-10-15: [Passwordless authentication: Secure, simple, and fast to deploy](https://hacks.mozilla.org/2014/10/passwordless-authentication-secure-simple-and-fast-to-deploy/)
* 2015-06-30: [Why passwords suck](https://medium.engineering/why-passwords-suck-d1d1f38c1bb4)
* 2016-08-12: [Securing access to genetic and personal information without a password](https://biogeniq.ca/en/articles/securing-access-to-genetic-and-personal-information-without-a-password/)
* [Passwordless](https://passwordless.net/)

The nomenclature has been settling on calling this approach "passwordless".
That makes sense if the email sent the user contains a link such that the user
never has to enter a password. However, this gem assumes that the device
receiving the password and the device being used to sign in may not be the same
and thus a password that can be read and entered is also a requirement. This
password can be used as a token for a "passwordless" authentication link. This
gem is "passwordless" but I believe more accurately it uses out-of-band
transmission of quickly expiring one-time passwords.

This approach may sound counter-intuitive, especially with a default password
length of 8 characters. However, the real key to the security is that the
passwords are sufficiently random and the window of opportunity is very short.
A traditional username / password system fails because the passwords are not
sufficiently random as truly random passwords are difficult to remember and
because the password lifetime is often very long. An issue which compounds
these traditional systems is password reuse which puts accounts at risk
whenever any system containing a user's password becomes compromised and
subject to a brute force attack.

### Benefits:

* No passwords to create - Users are generally very bad at creating passwords
unless they are highly disciplined. The requirement to remember the
password is directly at odds with the strength of the password.
* No passwords to remember - Passwords can be random and arbitrarily
strong by increasing password length.
* Passwords are short lived - Brute-force attacks are thwarted even with
shorter passwords such as 8 random letters.
* Passwords are not reused - A system using this gem cannot divulge useful
password secrets if compromised. It is also immune from secrets divulged from
other systems, whether they use this gem or not.
* Easy for users - To Sign In:
  1. enter your email
  2. enter the password that has been emailed to you or click a link in the
     email.

### Limitations:

* A compromised email account will compromise the user account. **However, this
is also true of any traditional password system that allows for email reset or
recovery of passwords.** The only way to circumvent this attack vector is to
handle password resets in a way that verifies a person's identity manually and
likely in person and with identification. Since most websites are probably not
willing to take that step (though financial institutions should be at the very
least considering it) then emailed one-time passwords are just as secure as
any website employing an automated email password reset system.
* Users must divulge an email account under their control to sign in. This does
not seem like a huge hurdle. If people are concerned with their privacy they
would likely have to create an anonymous/pseudonymous email for use with these
systems. Many websites require divulging an email even with a traditional
password system.
* Password emails can potentially create a log of usage. The existence of the
email cannot prove a user signed in or was trying to sign in since such emails
can be triggered by anyone. However, this is still a notable difference from
traditional systems.
* Relies on external email systems to deliver passwords. Any downtime in either
the email service used by the system or that used by the user will disrupt the
user's ability to sign in.

### Brute-force attacks:

Let's assume a malicious agent wants to brute-force a user's password on a
system using this gem. Using the default settings of an 8 letter password:

26^8 = 208,827,064,576 permutations

In order to compromise a password in 5 minutes an adversary will have to
hash nearly 700 million passwords per second.

26^8 permutations / 300 seconds = 696,090,216 hashes per second

This is far beyond what computing power can deliver for the bcrypt with a
default cost of 12. This scenario also assumes instantaneous access to the
stored crypted passwords which is highly unlikely without a greater breach of
security having already occurred.

On my development system the speed of bcrypt at cost 12 is roughly
4 hashes per second per core. A 2015 attempt to crack bcrypt passwords with a
cost of 12 using a GPU was able to achieve
[156 hashes per second per GPU](http://www.pxdojo.net/2015/08/what-i-learned-from-cracking-4000.html "What I learned from cracking 4000 Ashley Madison passwords").
A Zynq 7045 FPGA device was able to achieve
[226 hashes per second](http://www.openwall.com/presentations/Passwords14-Energy-Efficient-Cracking/slide-50.html "Energy-efficient bcrypt cracking, slide 50")
at bcrypt cost 12.
