use inc::Module::Install;

name 'DateTime-Easy';
all_from 'lib/DateTime/Easy.pm';

build_requires 'Test::More';

requires 'Date::Manip' => 0;
requires 'DateTime' => 0;

auto_install;

WriteAll;

