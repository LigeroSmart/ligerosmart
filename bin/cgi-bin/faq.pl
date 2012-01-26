#!/usr/bin/perl -w
# --
# faq.pl - the global CGI handle file for OTRS
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: faq.pl,v 1.5 2012-01-26 16:37:39 mh Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

use vars qw($VERSION @INC);
$VERSION = qw($Revision: 1.5 $) [1];

# 0=off;1=on;
my $Debug = 0;

# check @INC for mod_perl (add lib path for "require module"!)
push( @INC, "$Bin/../..", "$Bin/../../Kernel/cpan-lib" );

print "location: public.pl?Action=PublicFAQExplorer\n";
print "\n";
print "<a href='public.pl?Action=PublicFAQExplorer'>moved</a>\n";
