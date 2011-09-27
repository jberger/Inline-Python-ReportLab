use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
  module_name        => 'Inline::Python::ReportLab',
  dist_version_from  => 'lib/Inline/Python/ReportLab.pm',
  dist_author        => 'Joel Berger <joel.a.berger@gmail.com>',
  license            => 'perl',
  requires => {
    'perl'              => '5.008',
    'Inline::Python'    => 0,
  },
  configure_requires => {
    'perl'              => '5.008',
    'Inline::Python'	=> 0,
  },
  build_requires => {
    'perl'              => '5.008',
    'Test::More'        => 0,
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

