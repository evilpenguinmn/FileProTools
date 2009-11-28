use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'FilePro::Screen',
    VERSION_FROM      => 'lib/FilePro/Screen.pm', # finds $VERSION
    PREREQ_PM         => { FilePro::Data => 0.01 }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/FilePro/Screen.pm', # retrieve abstract from module
       AUTHOR         => 'Michael Schwarz <mschwarz@technodane.com>') : ()),
);
