
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601",
    "Test::More" => "0.98"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Implementation for Unixish, a data transformation framework",
  "dist_author" => [
    "Steven Haryanto <stevenharyanto\@gmail.com>"
  ],
  "dist_name" => "Data-Unixish",
  "dist_version" => "1.34",
  "license" => "perl",
  "module_name" => "Data::Unixish",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Log::Any" => 0,
    "Number::Format" => 0,
    "Rinci" => "v1.1.0",
    "SHARYANTO::Number::Util" => "0.38",
    "SHARYANTO::Package::Util" => 0,
    "SHARYANTO::String::Util" => "0.24",
    "Syntax::Feature::EachOnArray" => 0,
    "Text::ANSI::Util" => "0.06",
    "Text::WideChar::Util" => "0.03",
    "Text::sprintfn" => 0,
    "Tie::Simple" => 0,
    "Unixish" => "v1.0.1",
    "perl" => "5.010001"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
