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

  $output = `module load octave; echo 'pkg load parallel;fun=@(x) x^2;vector_x=1:10;vector_y=pararrayfun(nproc,fun,vector_x)' |octave 2>&1`;
  like($output, qr/parcellfun: 10\/10 jobs done/, 'octave parallel package test');
  $output = `module load octave; echo 'pkg load signal;x=1:.5:10;y=sawtooth(x,1)' |octave 2>&1`;
  like($output, qr/-0.453521  -0.294366  -0.135211   0.023944   0.183099/, 'octave signal package test');
  `/bin/ls /opt/modulefiles/applications/octave/[0-9.]* 2>&1`;
  ok($? == 0, 'octave module installed');
  `/bin/ls /opt/modulefiles/applications/octave/.version.[0-9.]* 2>&1`;
  ok($? == 0, 'octave version module installed');
  ok(-l '/opt/modulefiles/applications/octave/.version',
     'octave version module link created');

}


`rm -fr $TESTFILE*`;
