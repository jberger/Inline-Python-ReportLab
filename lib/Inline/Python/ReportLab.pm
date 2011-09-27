package Inline::Python::ReportLab;

use strict;
use warnings;

our $VERSION = 0.010;
$VERSION = eval $VERSION;

=head1 NAME

Inline::Python::ReportLab - PDF Generation using Python's ReportLab

=head1 SYNOPSIS

 use Inline::Python::ReportLab;
 my $canvas = Inline::Python::ReportLab->Canvas('filename.pdf');
 $canvas->drawString(100,100,"Hello World");
 $canvas->showPage();
 $canvas->save();

=head1 DESCRIPTION

L<Inline::Python::ReportLab> is a VERY naive wrapper around Python's popular PDF generation library L<ReportLab|http://www.reportlab.com/>. It uses the magic of L<Inline::Python>, so that must be installed, as must the C<python> interpreter itself, and the Python ReportLab library obviously.

This module should be viewed as a starting point awaiting contributions. See L<Source Repository> to see where to go to help. The author wrote the module as a proof-of-concept, but would like to see it go farther if people are interested in contributing.

=cut

use Carp;
use Try::Tiny;

use Inline::Python qw/py_eval/;
our @ISA = 'Inline::Python::Object';

BEGIN {
  *Canvas = \&new;
}

=head1 IMPORT

On importing it simply executes C<py_eval('from reportlab.pdfgen.canvas import Canvas')>, which imports the library. This croaks if the ReportLab library cannot be imported.

The module does not export any symbols.

=cut

sub import {
  try {
    py_eval('from reportlab.pdfgen.canvas import Canvas');
  } catch {
    croak "Inline::Python could not import ReportLab, is it installed correctly?";
  }
}

=head1 CONSTRUCTOR

 my $c = Inline::Python::ReportLab->new('filename.pdf');
   -- or --
 my $c = Inline::Python::ReportLab->Canvas('filename.pdf');

The constructor class method C<new> (which has an alias C<Canvas> for better analogy to the Python version), requires one argument, the name of the file to be created. It returns a C<Inline::Python::ReportLab> object (which is a subclass of C<Inline::Python::Object>) which behaves like the equivalent Python object using Perl syntax.

=cut

sub new {
  my $class = shift;
  my $filename = shift || croak "Must specify file name to contructor";
  return bless(Inline::Python::Object->new('__main__', 'Canvas', $filename), $class);
}

=head1 SEE ALSO

=over

=item *

L<Inline::Python>

=item *

L<ReportLab|http://www.reportlab.com/>

=back

=head1 SOURCE REPOSITORY

L<http://github.com/jberger/Inline-Python-ReportLab>

=head1 AUTHOR

Joel Berger, E<lt>joel.a.berger@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Joel Berger

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

