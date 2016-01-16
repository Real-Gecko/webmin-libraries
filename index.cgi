#!/usr/bin/perl
# Libraries module

require './libraries-lib.pl';
&foreign_require('webmin', 'webmin-lib.pl');
use lib './lib';
&init_config();

&ui_print_header(undef, $text{'index_title'}, "", undef, 1, 1);

if($gconfig{'no_content_security_policy'}) {
    print "CSP is disabled in global configuration, CDN will be available<br>";
} else {
    print "CSP is enabled in global configuration, CDN will be inacccessible<br>";
}

print &ui_table_start("Following modules use libraries API", "width=100%");

# Get modules info
@modules = &webmin::get_all_module_infos();
# Filter out installed
@installed = map {$_} grep { $_->{'installed'} ==  1 } @modules;
# Filter out those declared "library"
@available = map {$_} grep { defined $_->{'library'} } @installed;

foreach(@available) {
    $name = $_->{'dir'};
    foreign_require($name);
    if(foreign_defined($name, 'libraries_require')) {
        print &ui_table_row("<a href='module_details.cgi?name=$name'>$name</a>", undef, 2);
    };
}

print &ui_table_end();

print "<a href='clear_cache.cgi'>Clear libraries cached HTML</a>";

ui_print_footer("/", $text{'index'});
