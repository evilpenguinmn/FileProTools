package FilePro::Data;

use 5.010000;
use strict;
use warnings;
use Data::Dumper;

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

our $iternum = 0;


# Preloaded methods go here.

sub new {
	my ($pkg, $dpath) = @_; 
	my $self = { fpdatapath => $dpath };

	die "No data path specified. You must name the base dir of a FilePro 'file'."
		unless (defined($dpath));
	
	die "Folder $self->{fpdatapath} does not exist" unless ( -d $self->{fpdatapath} );
	die "Cannot read $self->{fpdatapath} map file" unless ( -r $self->{fpdatapath}."/map" );
	die "Cannot read $self->{fpdatapath} key file" unless ( -r $self->{fpdatapath}."/key" );

	$self->{map} = fp_populate_map($self->{fpdatapath}."/map");

	$self->{numkeyrecs} = (-s $self->{fpdatapath}."/key") / ($self->{map}->{keyreclen}+20);

	## We open a handle to the "key" file, which stores the data records and
	## we keep it around for later use.
	open KEYFILE, "<".$self->{fpdatapath}."/key" or die "Cannot open key file";
	binmode(KEYFILE);
	$self->{keyfile} = \*KEYFILE;

	bless($self, $pkg);
	return $self;
}

## This is meant to be a "static" method. It doesn't expect a
## "self" parameter. This parses the FilePro map file and stores
## the result in a hash; a reference to which is placed in the
## object instance.
sub fp_populate_map($) {
	my ($path) = @_;

	my $map = {};

	open MAPFILE, "<$path";

	# First we read the header line of the file
	my $line = <MAPFILE>;

	(undef, $map->{keyreclen}, $map->{datareclen}, $map->{pwchksum}, $map->{passwd}) = split(/:/, $line);

	my $cols = [];

	while (<MAPFILE>) {
		my $coldesc = {};
		my $clen;

		($coldesc->{cname}, $clen, $coldesc->{ctype}) = split(/:/);
		$coldesc->{clen} = $clen+0;
		push(@$cols, $coldesc);
	}

	close MAPFILE;

	$map->{cols} = $cols;

	return $map;
}

## This returns a raw copy of the record at position $rownum in the
## FilePro key file opened in this object. FilePro "rows" may contain
## data or may be marked "deleted." While this may be called by users
## of this class, we expect that most of the time the getRowHash method
## would be used as it decodes the header and parses the data into
## a hash that is easier for programs to use.
sub getRowRaw {
	my ($self, $rownum) = @_;
	my $rec;

	seek($self->{keyfile}, $rownum * ($self->{map}->{keyreclen}+20), 0);
	if (read($self->{keyfile}, $rec, $self->{map}->{keyreclen}+20) != $self->{map}->{keyreclen}+20) {
		return undef;
	}

	return $rec;
}

## This returns a hash of the parsed header and the data (if any) at position
## $rownum in the key file. The most important hash key is probably {fp_notdeleted}
## which will be non-zero (true) if there is data in $rownum.
##
## The raw header and raw data (if any) are available as {fp_rawheader} and
## {fp_rawrow} respectively. The fields are also parsed into a hash based on the
## map file contents. There is an array reference at {cols}. Each element of
sub getRowHash {
	my ($self, $rownum) = @_;
	my $reclen = ($self->{map}->{keyreclen})+0;

	my $res = {};

	my $rawrow = $self->getRowRaw($rownum);

	if (!defined($rawrow)) {
		return undef;
	}

	($res->{fp_rawheader}, $res->{fp_rawrow}) = unpack("a20a".$self->{map}->{keyreclen}, $rawrow);

	($res->{fp_notdeleted}, undef, $res->{fp_cdate}, $res->{fp_cid}, $res->{fp_udate}, $res->{fp_uid}, $res->{fp_buid}) =
		unpack("CCSSSSS", $res->{fp_rawheader});

	my $remainder = $res->{fp_rawrow};

	foreach (@{$self->{map}->{cols}}) {
		$reclen -= $_->{clen};
		($res->{$_->{cname}}, $remainder) = unpack("a".$_->{clen}."a".$reclen, $remainder);
	}

	return $res;
}

sub getDataCount {
	my ($self) = @_;

	return (-s $self->{fpdatapath}."/key") / ($self->{map}->{keyreclen}+20);
}

sub getRowCount {
	my ($self) = @_;
	my $count = 0;

	for (my $i = 0; $i < $self->getDataCount(); $i++) {
		my $row = $self->getRowHash($i);
		$count++ if ($row->{fp_notdeleted});
	}

	return $count;
}

sub newIterator {
	my ($self) = @_;
	my $nextitr = "iter".$iternum++;

	$self->{$nextitr} = 0;

	return $nextitr;
}

sub getNextRowHash {
	my ($self, $iter) = @_;
	my $res;

	die "Iterator does not exist" unless defined($self->{$iter});

	while ($res = getRowHash($self, $self->{$iter}++)) {
		last if ($res->{fp_notdeleted});
	}

	return $res;
}


1;
__END__
# Below is POD Documentation

=head1 NAME

FilePro::Data - Perl extension for reading data from FilePro "files."

=head1 SYNOPSIS

  use FilePro::Data;

  my $fph = FilePro::Data->new("/appl/filepro/fpfile");

  $fpobjref = FilePro::Data->new($filepro_data_dir_path);

This constructor will instantiate a FilePro::Data object for the
data table stored in the $filepro_data_dir_path. The constructor
fails if any stage of the constuction fails.

The directory must exist, it must contain a "map" file, it must contain a "key" file.

We intend to support indexes, reports, and screens, but for now these two will
let you extract data from the tables.

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
