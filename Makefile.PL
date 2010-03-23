use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Sub::Fork',
    VERSION_FROM      => 'lib/Sub/Fork.pm', # finds $VERSION
    PREREQ_PM         => {
        'IPC::Lite' => 0.4.35,
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Sub/Fork.pm', # retrieve abstract from module
       AUTHOR         => 'A. U. Thor <i.trunaev@localdomain>') : ()),
);
