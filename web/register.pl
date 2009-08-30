#!/usr/bin/perl

use strict;

use lib "/home/spoj0/";
use Time::localtime;
use DBI;
use spoj0;
use CGI qw/:standard :html3/;

my $dbh = SqlConnect;

my $title = "Register";
print header(-charset=>'utf-8'),
	start_html($title),
	WebNavMenu,
	h1($title);

my $ok = 0;
if(param('username') || param('password')){
	$ok = SubmitForm();
}

$ok or PrintForm();

print end_html;


sub Field{
	my $desc = shift or die;
	my $name = shift or warn;	
	return td({-align=>'right'}, $desc).
        td({-align=>'left'}, textfield($name, param($name)));
}

sub PrintForm {
	my @lang_names = keys %LANGUAGES;
	my $language = param('language') || $DEFAULT_LANG;
	
	print qq(
		<p>
			Поради големия брой потребители които трябваше да регистрирам ръчно, се предадох и направих тази форма. Ако някой не е регистриран и иска да участва в състезанията, нека го направи от тук. Регистриран потребител може да участва във всички състезания (не е необходима регистрация за отделни състезания или нещо такова).
		</p>
		<p>
			<strong>Внимание!</strong>, ако искате да се регистрирате, имайте предвид следните неща:
			<ul>
				<li>Трябва да попълните валидни данни.</li>
				<li>Препоръчва се кирилица за данните (за които е адекватно разбира се).</li>
				<li>Паролата не е необходимо да е много силна.</li>
				<li>Регистрацията се прави само веднъж, така че бих бил благодарен ако попълните валидни и пълни данни.</li>
				<li>Потребители, които администриращите сметнат за нереални ще бъдат деактивирани.</li>
				<li>Ако вашият акаунт бъде деактивиран, свържете се с администратор за да се разреши проблема.</li>
				<li>Системата е далеч от перфектна, и бих бил много благодарен да не злоупотребявате с нея, и да алармирате за видяни проблеми.</li>
				<li>От долните полете попълнете тези които са смислени за вас.</li>
				<li>Задължително е да оставите някакъв контакт.</li>
			</ul>
		</p>

	);

	print start_form(),
		table(
			{'-border'=>0},
        	undef,
        	Tr({-align=>'center'}, [
				Field("Потребителско име:", 'name'),
        		
        		td({-align=>'right'}, "Парола:").
        			td({-align=>'left'}, password_field('password', param('password'))),
        		
				Field("Пълно име (поне две имена):", "display_name"),
				Field("Град:", "city"),
				Field("Учебно Заведение/Организация:", "inst"),
				Field("Факултетен Номер (ако е приложимо):", "fn"),
				Field("email:", "email"),
				Field("icq:", "icq"),
				Field("skype:", "skype"),
				Field("друго (друго интересно):", "other"),
        			
        		td({-align=>'center'}, submit(-label=>'Submit')).
        			td({-align=>'left'}, "")
        	]
        	
        	)
    	),
    	end_form;
    	
}

sub SubmitForm{
	my $error = "Успяхме (май) :)";
	my $r = 0;
	
	#TODO: no check for duplicates!!! (not concurent safe)
	if(Login($dbh, param('name'), param('password'))){
		$error = "Вече има такъв потребител!";
	}
	elsif(length(param('display_name')) < 5){
		$error = "Не сте въвели пълно име!";
	}
	else{
		my %user_data = (
			'name' => param('name'),
			'password' => param('password'),
			'display_name' => param('display_name'),
			'about' => ""
		);
		$user_data{'about'} .= " city:".param('city') if(param('city'));
		$user_data{'about'} .= " inst:".param('inst') if(param('inst'));
		$user_data{'about'} .= " fn:".param('fn') if(param('fn'));
		$user_data{'about'} .= " email:".param('email') if(param('email'));
		$user_data{'about'} .= " icq:".param('icq') if(param('icq'));
		$user_data{'about'} .= " skype:".param('skype') if(param('skype'));
		$user_data{'about'} .= " other:".param('other') if(param('other'));
		$r = RegisterUser $dbh, \%user_data;
		$r or $error = "Грешка (някаква)";
	}
	print p(strong($error));
	return $r;
}
