# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::EnsEMBL::Pipeline::Config::GeneBuild::Slamconf - imports global variables used by EnsEMBL gene building

=head1 SYNOPSIS
use Bio::EnsEMBL::Pipeline::Config::GeneBuild::Slamconf;
use Bio::EnsEMBL::Pipeline::Config::GeneBuild::Slamconf qw(  );

=head1 DESCRIPTION

Slamconf is a pure ripoff of humConf written by James Gilbert.

humConf is based upon ideas from the standard perl Env environment
module.

It imports and sets a number of standard global variables into the
calling package, which are used in many scripts in the human sequence
analysis system.  The variables are first decalared using "use vars",
so that it can be used when "use strict" is in use in the calling
script.  Without arguments all the standard variables are set, and
with a list, only those variables whose names are provided are set.
The module will die if a variable which doesn\'t appear in its
C<%Slamconf> hash is asked to be set.

The variables can also be references to arrays or hashes.

Edit C<%Slamconf> to add or alter variables.

All the variables are in capitals, so that they resemble environment
variables.

=head1 CONTACT

=cut


package Bio::EnsEMBL::Pipeline::Config::GeneBuild::Slamconf;

use strict;
use vars qw( %Slamconf );



# Hash containg information for Slam-run. The base working-database is passed by SlamDB.pm

%Slamconf = (  

              SLAM_ORG1_NAME => 'H.sapiens'  ,                     # (valid species : R.Norvegicus, H.sapiens or M.musulus)
              SLAM_ORG2_NAME => 'M.musculus' ,


              # Slam-options
              
              SLAM_BIN => '/nfs/acari/jhv/bin/slam',
              SLAM_PARS_DIR => '/nfs/acari/jhv/lib/slam_pars_dir',
              SLAM_MAX_MEMORY_SIZE => '1572864',                   # default is 1572864 (1.5 gig)
              SLAM_MINLENGTH => '250',
              SLAM_MAXLENGTH => '200000',                          # Slam.pm- default is 100500 bp. max length of regions to compare

              # DB-configurations for second species

              SLAM_COMP_DB_USER => 'anonymous' ,
              SLAM_COMP_DB_PASS => '' ,
              SLAM_COMP_DB_NAME => 'mus_musculus_core_22_32b' ,
              SLAM_COMP_DB_HOST => 'kaka.sanger.ac.uk' ,
              SLAM_COMP_DB_PORT => '' ,

              SLAM_ORG2_RESULT_DB_USER  => 'ensadmin' ,
              SLAM_ORG2_RESULT_DB_PASS  => 'ensembl' ,
              SLAM_ORG2_RESULT_DB_NAME  => 'zz_test_jhv_slam_results_org2' ,
              SLAM_ORG2_RESULT_DB_HOST  => 'ecs1.internal.sanger.ac.uk' ,
              SLAM_ORG2_RESULT_DB_PORT  => '3306'
           );




    ################################################################################


sub import {
my ($callpack) = caller(0); # Name of the calling package
my $pack = shift; # Need to move package off @_

# Get list of variables supplied, or else

my @vars = @_ ? @_ : keys( %Slamconf );
return unless @vars;

# Predeclare global variables in calling package
eval "package $callpack; use vars qw("
. join(' ', map { '$'.$_ } @vars) . ")";
die $@ if $@;


foreach (@vars) {
if ( defined $Slamconf{ $_ } ) {
no strict 'refs';
# Exporter does a similar job to the following
# statement, but for function names, not
# scalar variables:
*{"${callpack}::$_"} = \$Slamconf{ $_ };
} else {
die "Error: File Slamconf.pm : $_ not known\n";
}
}
}

1;