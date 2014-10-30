#!/usr/bin/perl -w
# octave roll installation test.  Usage:
# octave.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $isInstalled = -d '/opt/octave';
my $output;

my $TESTFILE = 'tmpoctave';

# octave-install.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok($isInstalled, "octave installed");
} else {
  ok(! $isInstalled, "octave not installed");
}

SKIP: {

  skip "octave not installed", 4 if ! $isInstalled;

  $output = `module load octave; echo 'exp(i*pi)' | octave 2>&1`;
  like($output, qr/ans = -1\.0000e\+00/, 'simple octave test');

  `/bin/ls /opt/modulefiles/applications/octave/[0-9.]* 2>&1`;
  ok($? == 0, 'octave module installed');
  `/bin/ls /opt/modulefiles/applications/octave/.version.[0-9.]* 2>&1`;
  ok($? == 0, 'octave version module installed');
  ok(-l '/opt/modulefiles/applications/octave/.version',
     'octave version module link created');

}


`rm -fr $TESTFILE*`;
