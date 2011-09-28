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

=head1 IMPORT

On importing it simply executes C<py_eval>'s import statements, which imports the library. This croaks if the ReportLab library cannot be imported.

The module does not export any symbols.

=head1 Inline::Python::ReportLab

=cut

my $canvas_class;
BEGIN {
  $canvas_class = 'reportlab.pdfgen.canvas';
}

BEGIN {
  try {
    py_eval( 'import reportlab' );
  } catch {
    croak "Inline::Python could not import ReportLab, is it installed correctly?";
  }

  py_eval( <<PYTHON );
import $canvas_class
PYTHON

}

=head2 CONSTRUCTOR

 my $c = Inline::Python::ReportLab->Canvas('filename.pdf');

The constructor class method C<Canvas> (named for better analogy to the Python version), requires one argument, the name of the file to be created. It returns a C<Inline::Python::ReportLab> object (which is a subclass of C<Inline::Python::Object>) which behaves like the equivalent Python object using Perl syntax.

=cut

sub Canvas {
  my $class = shift;
  my $filename = shift || croak "Must specify file name to contructor";
  return bless(Inline::Python::Object->new($canvas_class, 'Canvas', $filename), $class);
}

=head1 Inline::Python::ReportLab::Platypus

Provides the constructor class methods from reportlab.platypus, read its documentation for more info. 

=cut

package Inline::Python::ReportLab::Platypus;

use strict;
use warnings;

use Inline::Python qw/py_eval py_study_package/;
our @ISA = 'Inline::Python::Object';

BEGIN {
  my $python_class = 'reportlab.platypus';

  py_eval( <<PYTHON );
import $python_class
PYTHON

  my %platypus = py_study_package($python_class);
  foreach my $object (keys %{$platypus{'classes'}}) {
    no strict 'refs';
    *{$object} = sub {
      my $class = shift;
      unshift @_, $object;
      return bless(Inline::Python::Object->new('reportlab.platypus', @_), $class);
    };
  }
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

