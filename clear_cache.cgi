#!/usr/bin/perl

require './libraries-lib.pl';
use WebminCore;

clear_cache();

&redirect("index.cgi?path=$path");
