package FilePro::Screen;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use FilePro::Screen ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

## Screen parsing class implementation

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

FilePro::Screen - Perl extension for reading FilePro "screen" files

=head1 SYNOPSIS

  use FilePro::Screen;

=head1 DESCRIPTION

This module will read a FilePro screen file and make its structure available
as a perl object.

=head2 EXPORT

None by default.



=head1 SEE ALSO

FilePro::Data
http://www.technodane.com/

=head1 AUTHOR

Michael Schwarz, E<lt>mschwarz@technodane.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by TechnoDane Software & Systems, LLC

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
