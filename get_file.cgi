#!/usr/bin/perl
# Libraries module
# Gets required file to be accessible locally, AJAX ready

require './libraries-lib.pl';
use WebminCore;

&ReadParse();

make_local($in{'lib'}, $in{'ver'}, $in{'file'});

print "Content-Security-Policy: script-src 'self' 'unsafe-inline'; frame-src 'self'\n";
print "Content-type: application/json; Charset=utf-8\n\n";
print "Done";