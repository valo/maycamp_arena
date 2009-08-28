#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;

my $dbh = SqlConnect;

my $title = "Submit";
print header(-charset=>'utf-8'),
	start_html($title),
	WebNavMenu,
	h1($title);

#warn param('upload') ? "fish" : "no";
if(param('upload') || param('paste_code')){
	submit_run();
}

print_form();

print end_html;


sub print_form {
	my @lang_names = keys %LANGUAGES;
	my $language = param('language') || $DEFAULT_LANG;
	print start_multipart_form(),
		table(
			{'-border'=>0},
        	undef,
        	Tr({-align=>'center'}, [
        		td({-align=>'right'}, "username:").
        			td({-align=>'left'}, textfield('username', param('username'))),
        		
        		td({-align=>'right'}, "password:").
        			td({-align=>'left'}, password_field('password', param('password'))),
        		
        		td({-align=>'right'}, "problem id:").
        			td({-align=>'left'}, textfield('problem_id', param('problem_id'))),
        		
        		td({-align=>'right'}, "about:").
        			td({-align=>'left'}, textfield(-name=>'about', -default=>param('about')||"", -size=>60)),
        		
        		td({-align=>'right'}, "language:").
        			td({-align=>'left'}, popup_menu(
        				-name=>'language', 
        				-values=>\@lang_names,
        				-labels=>\%LANGUAGES, 
        				-default=>$language)),

        		td({-align=>'right'}, "upload file:").
        			td({-align=>'left'}, filefield(-name=>'upload',-size=>60)),
        			
        		td({-align=>'right'}, "or paste code:").
        			td({-align=>'left'}, textarea(-name=>'paste_code', 
        				-default=>param('paste_code') || "", -rows=>25, -columns=>80)),
        			
        		td({-align=>'center'}, submit(-label=>'Submit')).
        			td({-align=>'left'}, "")
        	]
        	
        	)
    	),
    	end_form;
    	

		#"Username:", textfield('username', param('username')),br,
		#"Password:", password_field('password', param('password')),br,
		#"Problem id:", textfield('problem_id', param('problem_id')),br,
		#"About:", textfield('about', param('about'), 60),br,
		#filefield(-name=>'upload',-size=>60),br,
		#submit(-label=>'Submit'),
		#end_form;
}

sub submit_run{
	my $error = '';
	
	if(param('paste_code') && param('upload')){
		$error = "You should either paste, or upload your code, not both!";
	}
	
	my $user_id;
	if(!$error){
		#check login
		$user_id = Login($dbh, param('username'), param('password'));
		if(!$user_id){
			$error = "Invalid username or password!";
		}
	}
	
	my $language = param('language') || $DEFAULT_LANG;
	
	my $source_name = $DEFAULT_SOURCE_FILE{$language};
	my $source_code = param('paste_code');
	if(!$error && param('upload')){
		$source_name = param('upload');
		$source_code = join '', <$source_name>;
		
		if(length($source_code) > 1024*1024){
			$error = "Can not submit files larger than 1MB!";
		}
	}
	if(!$error){
		my $prob = GetProblemInfo(\$dbh, param('problem_id'));
		$prob or $error = "No such problem!";
	}
	
	
	my $run_id;
	if(!$error){
		my %run_data = (
			'problem_id' => param('problem_id'),
			'user_id' => $user_id,
			'submit_time' => SqlNow(),
			'language' => $language,
			'source_code' => $source_code,
			'source_name' => $source_name,
			'about' => param('about'),
			'status' => 'waiting',
			'log' => ''
		);
		SqlInsert \$dbh, 'runs', \%run_data;
		$run_id = $dbh->last_insert_id(undef, 'spoj', 'runs', 'run_id'); 
	}
	if(!$error){
		$error = "Successfully submitted run $run_id";
	}
	print p(strong($error));
}

sub print_results {
	my $length;
	my $file = param('upload');
	if (!$file) {
		print "No file uploaded.";
		return;
	}
	print h2('File name'),$file;
	print h2('File MIME type'),
	uploadInfo($file)->{'Content-Type'};
	while (<$file>) {
		$length += length($_);
	}
	print h2('File length'),$length;
	print h2('User Name'),param('username');
	print h2('Pass'),param('password');
}
