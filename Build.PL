
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601",
    "Test::More" => "0.96"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Data transformation framework, inspired by Unix toolbox philosophy",
  "dist_author" => [
    "Steven Haryanto <stevenharyanto\@gmail.com>"
  ],
  "dist_name" => "Data-Unixish",
  "dist_version" => "1.0.0",
  "license" => "perl",
  "module_name" => "Data::Unixish",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Data::Unixish::Implementation" => "0.01",
    "Rinci" => "1.1.0",
    "perl" => "5.010000"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
