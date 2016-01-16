# libraries-lib.pl

BEGIN { push(@INC, ".."); };
use lib "./lib";
use WebminCore;

use File::Basename;
use File::Path qw/make_path/;

init_config();

$cdn_url = $config{'cdn_url'};
if ($config{'source'} eq '0') {
    $source = "/$config{'install_path'}";
} else {
    $source = $cdn_url;
}
$install_path = "$root_directory/$config{'install_path'}";

# sub make_local()
# Downloads the given file to be locally available
sub make_local {
    my ($library, $version, $file) = @_;

    if(!-e "$install_path/$library/$version/$file") {
        my ($host, $port, $page, $ssl) = &parse_http_url("$cdn_url/$library/$version/$file");
        my $dir = dirname("$install_path/$library/$version/$file");
        make_path($dir);
        &http_download($host, $port, $page, "$install_path/$library/$version/$file", undef, undef, $ssl);
    }
}

# sub head_include_file()
# Return HTML markup for the given file, ready to be included in <head></head>
sub head_include_file {
    my ($library, $version, $file) = @_;
    my $type = &guess_mime_type($file);
    if ($type eq "application/x-javascript") {
        return "<script type=\"text/javascript\" src=\"$source/$library/$version/$file\"></script>";
    }
    if ($type eq "text/css") {
        return "<link rel=\"stylesheet\" type=\"text/css\" href=\"$source/$library/$version/$file\" />";
    }
}

# sub head_libraries()
# Returns HTML markup for the given @libraries array
sub head_libraries {
    my @libraries = @_;
    my $result = "";
    foreach $library(@libraries) {
        # Try to get cached version of result for given library
        if (-e "$module_config_directory/$library->{'name'}-$library->{'version'}.cache") {
            $result .= &read_file_contents("$module_config_directory/$library->{'name'}-$library->{'version'}.cache");
        } else {
            # Not cached, build HTML string from scratch
            my $libres = "";
            foreach $file(@{$library->{'files'}}) {
                if($config{'source'} eq '0') {
                    make_local($library->{'name'}, $library->{'version'}, $file);
                }
                $libres .= head_include_file($library->{'name'}, $library->{'version'}, $file);
            }
            # Write HTML string to cache
            open(my $fh, ">", "$module_config_directory/$library->{'name'}-$library->{'version'}.cache");
            print $fh $libres;
            close($fh);
            $result .= $libres;
        }
    }
    return $result;
}

# sub clear_cache()
# Clears libraries cache
sub clear_cache {
    @cache = glob "$module_config_directory/*.cache";
    &unlink_file(@cache);
}

sub require_libraries {
    my (%libraries) = %{$_[0]};
    my $files = $libraries{'jquery'}{'files'};
    print Dumper $files;
    foreach $file(@{$libraries{'jquery-ui'}{'files'}}) {
        print "-- ".$file;
    }
}

sub get_installed {
    opendir ( DIR, "unauthenticated" );
    @libraries = map { $_ } grep { $_ ne '.' && $_ ne '..' } readdir(DIR);
    closedir(DIR);
    return @libraries;
}

1;

