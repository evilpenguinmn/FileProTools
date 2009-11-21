package FilePro::Data;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use FilePro::Data ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

=pod

$fpobjref = FilePro::Data->new($filepro_data_dir_path);

This constructor will instantiate a FilePro::Data object for the
data table stored in the $filepro_data_dir_path. The constructor
fails if any stage of the constuction fails.

The directory must exist, it must contain a "map" file, it must contain a "key" file.

We intend to support indexes, reports, and screens, but for now these two will
let you extract data from the tables.

=cut

sub new {
	my $pkg = shift;
	my $self = { fpdatapath => shift; }
	
	die "Folder $self->{fpdatapath} does not exist" unless ( -d $self->{fpdatapath} );

	bless($self, $pkg);
	return $self;
}



1;
__END__
# Below is POD Documentation

=head1 NAME

FilePro::Data - Perl extension for reading data from FilePro "files."

=head1 SYNOPSIS

  use FilePro::Data;

  my $fph = FilePro::Data->new("/appl/filepro/fpfile");


=head1 DESCRIPTION

FilePro::Data is an object-oriented perl interface to read FilePro data files.
A FilePro "file" is a directory containing a series of files that define the
structure and contents of the data, and possibly additional files that 
represent indexes into the data, reports, and edit screens.

FilePro is a fairly "old school" tool, resembling classic "3270" batch style
"glass teletype" applications. It does a nice job of this, but there are fewer
and fewer people familiar with this kind of environment every year. The 
purpose of the TechnoDane FilePro libraries is facilitate moving data out of 
this system, perhaps to a more modern environment.

The authors of this library have developed a practice around converting 
FilePro applications into "LAMP" (Linux, Apache, MySQL, PHP) applications. In
so doing they developed these perl libraries and have contributed them to the
open source community.

You can contact the authors (or their corporations; TechnoDane Software & 
Systems, LLC or AnderSand Inc.)

Be aware that in the present version, not only is this interface read-only,
but it ignores the FilePro locking mechanism. This library should only be
used against a static (not actively used by FilePro) copy of the data
files.

=head2 EXPORT

None by default. We suggest that you use the "new" method as described
above and access methods through that.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Michael Schwarz, E<lt>mschwarz@technodane.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Michael Schwarz

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
