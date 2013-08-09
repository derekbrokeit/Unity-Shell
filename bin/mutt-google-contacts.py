#!/usr/bin/env python
# This code originally found at:
# http://chsc.wordpress.com/2011/06/07/mutt-query-googlec/

# Version 0.1 Copyright (C) 2011 Christof Schmitt
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.

# This script parses the output of 'google contacts list'
# (http://code.google.com/p/googlecl/wiki/ExampleScripts#list) and
# prints the queried email address in the format required by mutt
# (http://www.mutt.org/doc/manual/manual-4.html#ss4.5).
#
# Usage: Install googlecl from
# http://code.google.com/p/googlecl/downloads/list and add
# set query_command = "mutt-google-contacts '%s'"
# to ~/.muttrc

import subprocess
import string
import sys

if not len(sys.argv) >= 2:
    print 'Usage: %s querystring' % sys.argv[0]
    sys.exit(1)

sys.stdout.write('Calling "google contacts list": ')

query = ' '.join(sys.argv[1:])
args = ['/opt/local/bin/google', 'contacts', 'list', '--title', '(?i).*' + query,
        '--fields', 'name,email', '--delimiter=;']

google = subprocess.Popen(args, stdout=subprocess.PIPE)
stdout, stderr = google.communicate()

if google.returncode != 0:
    print 'error'
    sys.exit(2)

print 'success'

for line in stdout.split('\n'):
    if len(line) > 0:
        name, emails = line.split(';')
        for email in emails.split(', '):
            if string.find(email, ' ') != -1:
                # with two or more addresses there is an additional
                # type (home, work, ...)
                typeoraddr, emailaddr = string.split(email, ' ')
                print emailaddr + '\t' + name + '\t' + typeoraddr
            else:
                # with only one address, there is no type field
                print email + '\t' + name
