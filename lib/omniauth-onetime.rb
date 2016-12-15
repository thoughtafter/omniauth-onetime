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
require 'omniauth'
require 'bcrypt'

require 'omniauth/omniauth-onetime/version'
require 'omniauth/strategies/onetime'
