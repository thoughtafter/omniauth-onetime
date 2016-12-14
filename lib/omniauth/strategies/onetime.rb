#
# omniauth-onetime - An omniauth strategy using secure onetime passwords.
# Copyright (C) 2016 thoughtafter@gmail.com
#
# This file is part of omniauth-onetime.
#
# omniauth-onetime is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# omniauth-onetime is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with omniauth-onetime.  If not, see <http://www.gnu.org/licenses/>.
#
module OmniAuth
  module Strategies
    # An omniauth strategy using secure onetime passwords
    class Onetime
      include OmniAuth::Strategy

      option :password_length, 8
      option :password_time, 5.minutes
      option :password_cost, 12
      option :password_cache, Rails.cache
      option :email_options, subject: 'Sign In Details'
      option :minimum_security, 100

      # hashes per second needed for 100% complete brute force
      # higher is more secure
      def self.difficulty
        (26**default_options[:password_length]) /
          default_options[:password_time]
      end

      # factor difficulty by password_cost to calculate metric for security
      # higher is more secure
      def self.security
        difficulty / (2**(32 - default_options[:password_cost]))
      end

      class_eval do
        if (s = security) < (m = default_options[:minimum_security])
          raise ArgumentError, 'Omniauth-Onetime options do not reach minimum' \
          " security requirements (#{s}<#{m}), please increase" \
          ' password_length, increase password_cost, or decrease password_time.'
        end
      end

      private

      # generate password of options[:password_length] length of uppercase
      # letters A-Z
      def new_password
        Array.new(options[:password_length]) do
          SecureRandom.random_number(26) + 65
        end.pack('c*')
      end

      # create cryoted oassword from plaintext using Bcrypt and save it to the
      # password cache
      def save_password(email, plaintext)
        crypted = BCrypt::Password
                  .create(plaintext, cost: options[:password_cost])
        options[:password_cache]
          .write(email, crypted, expires_in: options[:password_time])
      end

      # verify password, case is insensitive and all spaces and characters
      # other than A-Z are stripped out
      def verify_password(email, plaintext)
        crypted = options[:password_cache].read(email)

        begin
          (BCrypt::Password.new(crypted) == plaintext.upcase.gsub(/\W/, ''))
        rescue BCrypt::Errors::InvalidHash
          false
        end
      end

      uid do
        request.env['omniauth.params']['email']
      end

      info do
        {
          name: uid,
          email: uid
        }
      end

      def send_password(email, plaintext)
        # break the password into groups of 4 letters for readability and
        # usability
        body = plaintext.scan(/.{4}/).join(' ')
        ActionMailer::Base
          .mail(options[:email_options].merge(to: email, body: body))
          .deliver_now
      end

      def prepare_password(email)
        # to prevent DOS do not send another password until previous one has
        # expired
        unless options[:password_cache].exist?(email)
          plaintext = new_password
          save_password(email, plaintext)
          send_password(email, plaintext)
        end
      end

      def request_email
        log :debug, 'STEP 1: Ask user for email'

        form = OmniAuth::Form.new(title: 'User Info')
        form.text_field :email, :email
        form.button 'Request Password'
        form.to_response
      end

      def request_password(email)
        log :debug, 'STEP 2: prepare password then ask user for password'
        prepare_password(email)

        form = OmniAuth::Form.new(title: 'User Info')
        form.text_field :password, :password
        form.html("<input type=\"hidden\" name=\"email\" value=\"#{email}\">")
        form.button 'Sign In'
        form.to_response
      end

      def request_verification(email, plaintext)
        log :debug, 'STEP 3: verify password'
        if verify_password(email, plaintext)
          redirect callback_path
        else
          redirect request_path
        end
      end

      def request_phase
        email = request.params['email']
        plaintext = request.params['password']

        if email.blank?
          request_email
        elsif plaintext.blank?
          request_password(email)
        else
          request_verification(email, plaintext)
        end
      end
    end
  end
end
