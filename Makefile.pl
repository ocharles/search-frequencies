#!/usr/bin/perl
use inc::Module::Install;

requires 'Moose';
requires 'DBD::SQLite';
requires 'DBI';
requires 'DateTime::Format::SQLite';
requires 'JSON::Any';
requires 'REST::Google';
requires 'XML::Simple';
requires 'Data::Entropy::Algorithms';
requires 'Module::Pluggable';

auto_install;
WriteAll;
