# log_parser.pl
# Functions for parsing this module's logs

do 'virtual-server-lib.pl';

# parse_webmin_log(user, script, action, type, object, &params)
# Converts logged information from this module into human-readable form
sub parse_webmin_log
{
local ($user, $script, $action, $type, $object, $p, $long) = @_;
if ($type eq "user") {
	return &text('log_'.$action.'_user', "<tt>$object</tt>",
					     "<tt>$p->{'dom'}</tt>");
	}
elsif ($type eq "users") {
	return &text('log_'.$action.'_users', $object, "<tt>$p->{'dom'}</tt>");
	}
elsif ($type eq "alias") {
	return &text('log_'.$action.'_alias', "<tt>$object</tt>");
	}
elsif ($type eq "admin") {
	return &text('log_'.$action.'_admin', "<tt>$object</tt>");
	}
elsif ($type eq "aliases") {
	return &text('log_'.$action.'_aliases', $object,
		     "<tt>$p->{'dom'}</tt>");
	}
elsif ($type eq "domain") {
	return &text('log_'.$action.'_domain', "<tt>$object</tt>");
	}
elsif ($type eq "domains") {
	return &text('log_'.$action.'_domains', $object);
	}
elsif ($type eq "balancer") {
	return &text('log_'.$action.'_balancer', "<tt>$object</tt>",
		     "<tt>$p->{'dom'}</tt>");
	}
elsif ($type eq "balancers") {
	return &text('log_'.$action.'_balancers', "<tt>$p->{'dom'}</tt>",$object);
	}
elsif ($type eq "resel") {
	return &text('log_'.$action.'_resel', "<tt>$object</tt>");
	}
elsif ($type eq "resels") {
	return &text('log_'.$action.'_resels', $object);
	}
elsif ($type eq "template") {
	return &text('log_'.$action.'_template', &html_escape($object));
	}
elsif ($type eq "templates") {
	return &text('log_'.$action.'_template', $object);
	}
elsif ($type eq "script") {
	return &text('log_'.$action.'_script', $object, $p->{'ver'},
		     "<tt>$p->{'dom'}</tt>");
	}
elsif ($type eq "scripts" && ($action eq "upgrade" || $action eq "uninstall" ||
			      $action eq "warn")) {
	return &text('log_'.$action.'_scripts', $object);
	}
elsif ($type eq "scripts") {
	local @scripts = map { /^(.*)\.pl$/ ? "<tt>$1</tt>" : "<tt>$_</tt>" }
			     split(/\0/, $p->{'scripts'});
	return &text('log_'.$action.'_scripts', join(" ", @scripts));
	}
elsif ($type eq "styles" && $action eq "add") {
	return &text('log_add_styles', $object);
	}
elsif ($type eq "styles" && $action eq "enable") {
	return $text{'log_enable_styles'};
	}
elsif ($type eq "database") {
	return &text('log_'.$action.'_database', "<tt>$object</tt>",
		     $text{'databases_'.$p->{'type'}},
		     "<tt>$p->{'dom'}</tt>");
	}
elsif ($type eq "links" || $type eq "linkcats" || $type eq "fields") {
	return $text{'log_'.$action.'_'.$type};
	}
elsif ($action eq "start" || $action eq "stop" || $action eq "restart") {
	return $text{'log_'.$action.'_'.$type};
	}
elsif ($action eq "backup" || $action eq "restore") {
	local @doms = split(/\0/, $p->{'doms'});
	if ($long) {
		return &text('log_'.$action.'_l', join(" ", map { "<tt>$_</tt>" } @doms));
		}
	else {
		return &text('log_'.$action, scalar(@doms));
		}
	}
elsif ($type eq "sched") {
	local $msg = $object eq 'all' ? $text{'log_sched_all'} :
		     $object eq 'none' ? $text{'log_sched_none'} :
		     $object eq 'virtualmin' ? $text{'log_sched_virtualmin'} :
					       &text('log_sched_doms', $object);
	return &text('log_'.$action.'_sched', $msg);
	}
elsif ($type eq "scheds") {
	return &text('log_'.$action.'_scheds', $object);
	}
elsif ($action eq "notify" || $action eq "mailusers") {
	return &text('log_'.$action, scalar(split(/\0/, $p->{'to'})));
	}
elsif ($action eq "shells") {
	return $text{'log_shells'.int($object)};
	}
elsif ($action eq "cmd" || $action eq "remote") {
	# Local or remote API call
	return &text('log_'.$action.($long ? '_l' : ''),
		     "<tt>$type</tt>",
		     "<tt>".&un_urlize($p->{'argv'})."</tt>");
	}
else {
	return $text{'log_'.$action};
	}
return undef;
}

