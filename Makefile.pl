#!/usr/bin/perl
use inc::Module::Install;

requires 'Moose';
requires 'DBD::SQLite';
requires 'DBI';
requires 'DateTime::Format::SQLite';
requires 'REST::Google';

auto_install;
WriteAll;
