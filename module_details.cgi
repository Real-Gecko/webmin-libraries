#!/usr/bin/perl

require './libraries-lib.pl';
use lib './lib';

&ReadParse();

&init_config();
&ui_print_header(undef, $text{'library_details'}, "");

$name = $in{'name'};

%info = get_module_info($name);

#print %info;
print "$info{'desc'} uses following libraries";

foreign_require($name);
@libraries = foreign_call($name, 'libraries_require');

$install_path = "$root_directory/$config{'install_path'}";
print "<script src='unauthenticated/js/main.js'></script>";

foreach $library(@libraries) {
    print &ui_hidden_table_start(
        $library->{'name'}." ".$library->{'version'},
        "width=100%", 2, $library->{'name'}
    );
    foreach $file(@{$library->{'files'}}) {
        my $lib = $library->{'name'};
        my $ver = $library->{'version'};
        $button = "<button type='button' onclick='getFile(\"$lib\", \"$ver\", \"$file\", this)'>Get</button>";
        my $installed = (-e "$install_path/$library->{'name'}/$library->{'version'}/$file") ? "Local" : $button;
        print &ui_table_row($file, $installed, 2);
    }
    print &ui_hidden_table_end($library->{'name'});
}

&ui_print_footer("index.cgi", $text{'previous_page'});
