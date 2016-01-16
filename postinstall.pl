#!/usr/bin/perl
# Libraries module
# Does not work

require 'web-lib-funcs.pl';

sub module_install {
    $config_directory = $ENV{'WEBMIN_CONFIG'};
    %gconfig = ( );
    &read_file_cached($config_file, \%gconfig);
    &lock_file("$config_directory/config");
    $gconfig{'no_content_security_policy'} = 1;
    &write_file("$config_directory/config", \%gconfig);
    &unlock_file("$config_directory/config");
}
