use strict;
use warnings;

use Test::More tests => 3;

use Inline::Python::ReportLab;

my $file = 'hello.pdf';

my $c = Inline::Python::ReportLab->Canvas($file);
ok($c->isa('Inline::Python::ReportLab'), "ISA I::P::RL");
ok($c->isa('Inline::Python::Object'), "ISA I::P::O");

$c->drawString(100,100,'Hello World');
$c->showPage();
$c->save();

ok( -e $file , "$file created" );

unlink $file if (-e $file);

