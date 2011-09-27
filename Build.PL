use strict;
use warnings;

use Module::Build;

my $class = Module::Build->subclass(
  code => <<'SUBCLASS_ACTION_CODE',
use Carp;
use Try::Tiny;
use Inline::Python qw/py_eval/;

sub ACTION_code {
  my $self = shift;
  try {
    py_eval('from reportlab.pdfgen.canvas import Canvas');
  } catch {
    ## do something here to keep CPANtesters happy, like
    # exit 0 if ($ENV{'AUTOMATED_TESTING'});
    croak "Inline::Python could not import ReportLab, is it installed correctly?";
  }
  $self->SUPER::ACTION_code;
}
SUBCLASS_ACTION_CODE
);

my $builder = $class->new(
  module_name        => 'Inline::Python::ReportLab',
  dist_version_from  => 'lib/Inline/Python/ReportLab.pm',
  dist_author        => 'Joel Berger <joel.a.berger@gmail.com>',
  license            => 'perl',
  requires => {
    'perl'           => '5.008',
    'Carp'           => 0,
    'Inline::Python' => 0,
    'Try::Tiny'      => 0,
  },
  configure_requires => {
    'perl'           => '5.008',
  },
  build_requires => {
    'perl'           => '5.008',
    'Test::More'     => 0,
  },
  meta_merge => {
    resources  => {
      Type => "git",
      Url  => "git://github.com:jberger/Inline-Python-ReportLab.git",
      Web  => "http://github.com/jberger/Inline-Python-ReportLab",
    }
  },
);

$builder->create_build_script;

