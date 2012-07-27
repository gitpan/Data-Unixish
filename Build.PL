
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
  "dist_abstract" => "Pass input unchanged",
  "dist_author" => [
    "Steven Haryanto <stevenharyanto\@gmail.com>"
  ],
  "dist_name" => "Data-Unixish",
  "dist_version" => "1.21.0",
  "license" => "perl",
  "module_name" => "Data::Unixish",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Log::Any" => 0,
    "Perinci::CmdLine" => "0.53",
    "Rinci" => "1.1.0",
    "SHARYANTO::Package::Util" => 0,
    "Tie::Diamond" => "0.03",
    "Unixish" => "1.0.1",
    "feature::each_on_array" => 0,
    "perl" => "5.010000"
  },
  "script_files" => [
    "bin/dux"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
