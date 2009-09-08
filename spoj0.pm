package spoj0;

use strict;
use Time::localtime;
use DBI;

use Exporter;
use vars qw(@ISA @EXPORT);

@ISA = ('Exporter');
@EXPORT = qw(
&ParseConf 
&SqlInsert 
&SqlSync 
&SqlNow &SqlConnect &System &WebNavMenu 
&Login 
&RegisterUser
&GetProblemInfo 
&GetContestInfo
&GetContestInfo
&GetContestExInfo
&GetRunInfo
&GetRunExInfo
&ReadFile
&WriteFile
&DirFiles
&DosToUnix 
&SqlSelect
&GetNews
&GetProblemsEx
&GetContestsEx
&WebError
$NAME
$HOME_DIR
$EXEC_DIR
$SETS_DIR
$NEWS_DIR
$STOP_DAEMON_FILE
$TESTER_ID
%LANGUAGES
%DEFAULT_SOURCE_FILE
$DEFAULT_LANG 
@TITLES
);

our $NAME = 'spoj0'; #the name of the system 
our $HOME_DIR = '/home/spoj0'; #home directory of the system
our $EXEC_DIR = '/home/spoj0run'; #where problems are executed
our $SETS_DIR = '/home/spoj0/sets'; #where problem sets are stored
our $NEWS_DIR = '/home/spoj0/news'; #where the news are stored
our $STOP_DAEMON_FILE = '/home/spoj0/spoj0-stop-daemon';

our $STATUS_WAITING = 'waiting';
our $STATUS_JUDGING = 'judging';
our $STATUS_OK = 'ok';
our $STATUS_CE = 'ce'; #compile error
our $STATUS_TL = 'tl'; #time limit
our $STATUS_CE = 'ce'; #compile error
our $STATUS_WA = 'wa'; #wrong answer
our $STATUS_PE = 'pe'; #presentation error (difference in whitespaces)
our $STATUS_RE = 're'; #runtime error

our $TESTER_ID = 1; #the identifier of the hidden test user from which solutions may be probed

our %LANGUAGES = (
	'cpp' => "Gnu C++ (Default Version)",
	'java' => "Java (Default Version)",
);

our %DEFAULT_SOURCE_FILE = (
	'cpp' => "program.cpp",
	'java' => "program.java",
);

our $DEFAULT_LANG = 'cpp';

our @TITLES = (
	"Споджо",
	"Спри да Пипаш Онлайн Джъджа 0",
	"Stancho and Pancho Online Jazz Oh",
	"Sofia Public Onlune Judge Zero",
	"Stand Proud Online Judge Zero",
	"Student Panic Online Judge 0",
	"Stop Playing Other Junk 0utside",
);

sub ParseConf{
	my $fn = shift or die;
	my $hash = shift or die;
	my $file;
	open $file, $fn or die "Can not open conf $fn : $!";
	while(<$file>){
		chomp;
		if(/(\w+)=(.+)$/){
			$hash->{$1} = $2;
		}
	}
	close $file;
}


sub SqlInsert{
	my $handle = shift or die; #ref
	my $table = shift or die;
	my $values = shift or die; #ref
	
	my $sql = "insert into $table set ";
	my @sql_parts = ();
	my @binds = ();
	
	foreach my $key(keys(%$values)){
		push @sql_parts, "$key=?";
		push @binds, $$values{$key};
	}
	$sql .= join(', ', @sql_parts);
	
#	print "$sql\n";
	
	foreach my $b(@binds){
#		print "\t$b\n";
	}
	
	$$handle->do($sql, undef, @binds);
}

#inserts or updates, depending on whether the things are present
sub SqlSync{

	my $handle = shift or die; #ref
	my $table = shift or die;
	my $values = shift or die; #ref
	my $keys = shift or die; #list ref
	
	my $q = " 1=1 ";
	foreach my $key(@$keys){
		$q .= " AND $key = ".$handle->quote($$values{$key});
	}
	my $found = scalar @{&SqlSelect($handle, "SELECT * FROM $table WHERE $q")};
	if(!$found){
		SqlInsert $handle, $table, $values;
	}
	else{
		my @sets = ();
		foreach my $key(keys %$values){
			push @sets, "$key=".$handle->quote($$values{$key});
		}
		my $set = join(',', @sets);
		
		$handle->do("UPDATE $table SET $set WHERE $q");
	}
}


sub SqlNow{
	my $tm = localtime;

	return sprintf("%04d-%02d-%02d %02d:%02d:%02d", $tm->year+1900, 
    	$tm->mon+1, $tm->mday, $tm->hour, $tm->min, $tm->sec);
}

sub SqlConnect{
	return DBI->connect('DBI:mysql:spoj0:localhost:3306',
		'spoj0_admin', 'stancho3', { RaiseError => 1, AutoCommit => 1 });
}

sub System{
	my $cmd = shift or die;
	print "running: $cmd\n";
	return system($cmd);
}

sub WebNavMenu{
	my $now = SqlNow;
	return qq(
		<a href="index.pl">index</a> - 
		<a href="news.pl">news</a> - 
		<a href="contests.pl">contests</a> - 
		<a href="submit.pl">submit</a> - 
		<a href="status.pl">status</a> - 
		<a href="register.pl">register</a>  
		--- <strong>$NAME</strong> at $now
	);
}

sub Login{
	#returns user_id on successfull login, or false value if failed
	my $dbh = shift or die;
	my $username = shift;
	my $password = shift;
	my $login_st = $dbh->prepare("SELECT * FROM users WHERE name=? AND pass_md5=MD5(?)");
	$login_st->execute($username, $password);
	my $res = $login_st->fetchrow_hashref;
	$login_st->finish;
	return $res ? $$res{'user_id'} : undef;
	
}

sub RegisterUser{
	my $dbh = shift or die;
	my $user = shift; #hash ref with name, password, display_name and about
	my $reg_st = $dbh->prepare(qq(
		INSERT INTO users SET name=?, pass_md5=MD5(?), display_name=?, about=?;)
	);
	my $res = $reg_st->execute($$user{'name'}, $$user{'password'}, 
		$$user{'display_name'}, $$user{'about'});
	return $res;
}

sub GetProblemInfo{
	#returns hash ref, or undef if no such
	my $dbh = shift or die;
	my $problem_id = shift or die;
	my $problem_st = $$dbh->prepare(	"SELECT * from problems where problem_id=?");
	$problem_st->execute($problem_id) or die "Unable to execute statment!";
	my $problem = $problem_st->fetchrow_hashref;
	$problem_st->finish;
	return $problem ? $problem : undef;
}

sub GetContestInfo{
	#returns hash ref, or undef if no such
	my $dbh = shift or die;
	my $contest_id = shift or die;
	my $contest_st = $$dbh->prepare(	"SELECT * from contests where contest_id=?");
	$contest_st->execute($contest_id) or die "Unable to execute statment!";
	my $contest = $contest_st->fetchrow_hashref;
	$contest_st->finish;
	return $contest ? $contest : undef;
}

#returns hash ref, or undef if no such
#provides extra information: 
#	c_active (whether the contest has started)
#	c_online (the contest is started and in online state)
#	c_offline (the contest is started and finished (offline state))
sub GetContestExInfo{
	my $dbh = shift or die;
	my $contest_id = shift or die;
	my $contest_st = $$dbh->prepare(qq^
		SELECT 
			contest_id,
			set_code,
			name,
			start_time,
			duration,
			show_sources,
			about,
			start_time <= NOW() as c_active,
			show_sources && UNIX_TIMESTAMP(NOW()) <= UNIX_TIMESTAMP(start_time) + duration*60 as c_online,
			show_sources && UNIX_TIMESTAMP(NOW()) > UNIX_TIMESTAMP(start_time) + duration*60 as c_offline
			
		from contests ;
where contest_id=?;
	^);
	$contest_st->execute($contest_id) or die "Unable to execute statment!";
	my $contest = $contest_st->fetchrow_hashref;
	$contest_st->finish;
	return $contest ? $contest : undef;
}



#returns hash ref, or undef is no such
sub GetRunInfo{
	my $dbh = shift or die;
	my $run_id = shift or die;
	my $run_st = $$dbh->prepare(	"SELECT * FROM runs WHERE id=?");
	$run_st->execute($run_id) or die "Unable to execute statment!";
	my $run = $run_st->fetchrow_hashref;
	$run_st->finish;
	return $run ? $run : undef;
}

#returns hash ref, or undef is no such
#gets information about the run, the user, the problem and the contest
sub GetRunExInfo{
	die "unimplemented";
# 	my $dbh = shift or die;
# 	my $run_id = shift or die;
# 	my $run_st = $dbh->prepare(qq(
# 		SELECT 
# 			r.run_id, 
# 			u.display_name as u_name,
# 			u.user_id,
# 			p.letter as p_letter,
# 			p.problem_id,
# 			c.contest_id,
# 			UNIX_TIMESTAMP(r.submit_time) as s_time,
# 			UNIX_TIMESTAMP(c.start_time) as c_time,
# 			c.duration,
# 			c.start_time > NOW() as c_active
# 			UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(c.start_time) < c.duration
# 			r.status
# 		FROM runs as r 
# 		INNER JOIN users as u ON r.user_id = u.user_id
# 		INNER JOIN problems as p ON r.problem_id = p.problem_id
# 		INNER JOIN contests as c ON p.contest_id = c.contest_id
# 		HAVING run_id = ?
# 		ORDER BY r.run_id
# 	));
# 
# 
# 	my $run_st = $$dbh->prepare(	"SELECT * from runs where run_id=?");
# 	$run_st->execute($run_id) or die "Unable to execute statment!";
# 	my $run = $run_st->fetchrow_hashref;
# 	$run_st->finish;
# 	return $run ? $run : undef;
}


#reads a whole file and returns it as string
sub ReadFile{
	my $fn = shift or die;
	my $file;
	open $file, $fn or warn "Cannot read $fn";
	$fn or return '';
	my $res = join '', <$file>;
	close $file;
	return $res;
}

#writes to a given filename given string
sub WriteFile{
	my $fn = shift or die;
	my $contents = shift;
	my $file;
	open $file, ">$fn" or die "Cannot write $fn";
	print $file $contents;
	close $file;
}

#returns all file names from a given dir
sub DirFiles{
	#TODO: it would be good to have filter as a second argument
	my $path = shift or die;
	my $dir;
	opendir($dir, $path) or die "couldn't open $path : $!";
	my @ls = sort(readdir($dir));
	closedir($dir);
	return @ls;
}


sub DosToUnix {
	my $fn = shift or die;
	my $text = ReadFile $fn;
	$text =~ s/\r//g;
	WriteFile $fn, $text;
}

sub SqlSelect{
	my $dbh = shift or die;
	my $query = shift or die;
	my $st = $dbh->prepare($query);
	$st->execute() or die "Unable to execute statment!";
	return $st->fetchall_arrayref({});
}


sub GetNews{
	my $dbh = shift or die;
	my $f = shift;
	my $q = "SELECT * FROM news WHERE 1=1 ";
	$q .= ' AND file='.$dbh->quote($$f{'file'}) 
		if $$f{'file'};
	$q .= ' ORDER BY new_id DESC ';
	return SqlSelect $dbh, $q;
}


sub GetProblemsEx{
	my $dbh = shift or die;
	my $f = shift;
	my $q = qq!
		SELECT 
			p.*,
			c.set_code as c_code,
			c.name as c_name,
			c.start_time as c_start,
			c.duration as c_duration,
			c.show_sources as c_show_sources,
			UNIX_TIMESTAMP(c.start_time) as c_ustart,
			UNIX_TIMESTAMP(NOW()) as unow,
			NOW() > c.start_time as c_active,
			(NOW() > c.start_time && 
				UNIX_TIMESTAMP(NOW()) < 
				UNIX_TIMESTAMP(c.start_time)+c.duration*60) as c_online
			
		FROM problems as p
		INNER JOIN contests as c 
		ON p.contest_id = c.contest_id
		HAVING 1=1 
		
	!;
	$q .= ' AND problem_id='.$dbh->quote($$f{'id'}) 
		if $$f{'id'};
	$q .= ' AND contest_id='.$dbh->quote($$f{'contest_id'}) 
		if $$f{'contest_id'};
	$q .= ' AND letter='.$dbh->quote($$f{'letter'}) 
		if $$f{'letter'};
	my $res = SqlSelect $dbh, $q;
	foreach my $r(@$res){
		$$r{'c_dir'} = $SETS_DIR.'/'.$$r{'c_code'};
		$$r{'p_dir'} = $$r{'c_dir'}.'/'.$$r{'letter'};
	}
	return $res;	
	#<-problem_id, contests_id
	#-> p_dir, c_dir
}

sub GetContestsEx{
	my $dbh = shift or die;
	my $f = shift;
	my $q = qq!
		SELECT 
			c.*,
			UNIX_TIMESTAMP(c.start_time) as c_ustart,
			UNIX_TIMESTAMP(NOW()) as unow,
			NOW() > c.start_time as c_active,
			(NOW() > c.start_time && 
				UNIX_TIMESTAMP(NOW()) < 
				UNIX_TIMESTAMP(c.start_time)+c.duration*60) as c_online
		FROM contests as c
		HAVING 1=1  
	!;
	$q .= ' AND contest_id='.$dbh->quote($$f{'id'}) if $$f{'id'};
	$q .= ' AND set_code='.$dbh->quote($$f{'set_code'}) if $$f{'set_code'};
	$q .= ' AND c_active'	if $$f{'active'};
	$q .= ' AND c_online'	if $$f{'online'};
	$q .= ' ORDER BY contest_id DESC'	if $$f{'reverse'};
	$q .= ' LIMIT '.$dbh->quote($$f{'limit'}) if $$f{'limit'};
	my $res = SqlSelect $dbh, $q;
	return $res;	
}

#GetContestsEx \$dbh, {
#	'id' => id
#	'active' => bool
#	'online' => bool
#	'reverse' => bool
#}

sub WebError{
	my $text = shift; 
	#print "Content-type: text/html\n\n";
	print "Error: $text\n";
	exit; 
}

1;

