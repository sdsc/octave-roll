#!/usr/bin/perl -w
# octave roll installation test.  Usage:
# octave.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my @packages = ('octave');
my $output;
my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my @MPIS = split(/\s+/, 'ROLLMPI');
my $SKIP = 'ROLLSKIP';
my $TESTFILE = 'tmpoctave';
my %CXX = ('gnu' => 'g++', 'intel' => 'icpc', 'pgi' => 'pgCC');

# octave-install.xml
my @compilerNames = map {(split('/', $_))[0]} @COMPILERS;
foreach my $package(@packages) {
  if($appliance =~ /$installedOnAppliancesPattern/ &&
     int(map {$SKIP =~ "${package}_$_"} @compilerNames) < int(@compilerNames)) {
    ok(-d "/opt/$package", "$package installed");
  } else {
    ok(! -d "/opt/$package", "$package not installed");
  }
}

SKIP: {

  foreach my $package(@packages) {
    skip "$package not installed", 3 if ! -d "/opt/$package";
    foreach my $compiler(@COMPILERS) {
      my $compilername = (split('/', $compiler))[0];
      next if $SKIP =~ "${package}_${compilername}";
      my $path = '/opt/modulefiles/applications' .
                 ($package =~ /eigen|octave/ ? '' : "/.$compilername");
      my $subpackage = $package =~ /eigen|octave/ ? $package : "$package/$compilername";
      `/bin/ls $path/$package/[0-9]* 2>&1`;
      ok($? == 0, "$subpackage module installed");
      `/bin/ls $path/$package/.version.[0-9]* 2>&1`;
      ok($? == 0, "$subpackage version module installed");
      ok(-l "$path/$package/.version",
         "$subpackage version module link created");
    }
  }

}


my ($packageHome, $testDir);

# octave
$packageHome = '/opt/octave';
SKIP: {
  skip 'octave not installed', 1 if ! -d $packageHome;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
#!/bin/bash
module load intel octave
echo 'exp(i*pi)' | octave
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  like($output, qr/ans = -1\.0000e\+00/, 'simple octave test');
}

`rm -fr $TESTFILE*`;
