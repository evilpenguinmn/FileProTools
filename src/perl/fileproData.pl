#! /usr/bin/perl -w
#
# $Id: fileproData.pl,v 1.3 2008-07-27 11:10:25 mschwarz Exp $
#
# This is a perl fuction library to support the parsing of
# filepro data. It makes extensive use of hash references to
# build complex data structures.
#

use warnings;
use strict;

package FilePro::Data;

sub openFileProFile {
	my ($fpdir) = @_;
	my (%FPDATA);
	my ($mapheader, $m, $fpkeysz, $fpcolcnt);

	$FPDATA{fpdir} = $fpdir;
	$FPDATA{numcols} = 0;
	$FPDATA{numrows} = 0;
	$FPDATA{cols} = 0;
	$FPDATA{rows} = 0;

	open my ($mapfile), $fpdir."/map" or die "Cannot open $fpdir/map";

	$FPDATA{filehandle} = $mapfile;

	$mapheader = <$mapfile>;
	#$mapheader = <$mapfile>;

	chomp $mapheader;

	($m, $fpkeysz, undef, $fpcolcnt) = split /:/, $mapheader;

	print "TRACE: m [$m] fpkeysz [$fpkeysz] fpcolcnt [$fpcolcnt]\n";

	$FPDATA{keysize} = $fpkeysz;
	$FPDATA{columncount} = $fpcolcnt;

	%FPDATA = %{getColumnDefs(\%FPDATA)};

	return \%FPDATA;
}

sub getColumnDefs($) {
	my ($FPREF) = @_;
	my ($maptext);
	my ($mapfile);
	my ($i);
	my (%FPDATA) = %$FPREF;
	my (@COLLIST);
	my ($colname, $colformat, $colsz);

	$mapfile = $FPDATA{filehandle};

	for ($i = 0; $i < $FPDATA{columncount}; $i++) {
		$maptext = <$mapfile>;
		chomp $maptext;
		($colname, $colformat, $colsz) = split /:/, $maptext;
		push @COLLIST, \[$colname, $colformat, $colsz];
	}

	$FPDATA{cols} = \@COLLIST;

	return \%FPDATA;
}


sub unpackScreen($) {
	my ($screenData) = @_;
}


1;

