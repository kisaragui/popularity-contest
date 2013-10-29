#! /usr/bin/perl 

use strict;

$ENV{PATH}="/bin:/usr/bin";

my %results=('all' => "../popcon-mail/results", 'stable' => "../popcon-mail/results.stable");
my $popbase = "../www";
my %popcon= ('all' => "", 'stable' => "/stable");
my %popfile=('all' => "all-popcon-results.gz", 'stable' => "stable-popcon-results.gz");
my %poptext=('all' => "todos los reportes", 'stable' => "Stable reports");
my $mirrorbase = "/srv/mirrors/debian";
my $docurlbase = "/";
my %popconver=("1.28" => "sarge", "1.41" => "etch", "1.46" => "lenny", "1.49" => "squeeze");
my %popver=();
my @dists=("main","contrib","non-free","non-US");
my @fields=("inst","vote","old","recent","no-files");
my %maint=();
my %list_header=(
"maint" => <<"EOF",
#<name> es el nombre del paquete fuente;
#
#Los campos siguientes son la suma de todos los paquetes a cargo de que el desarrollador:
EOF
"source" => <<"EOF",
#<name> es el nombre del paquete fuente;
#
#Los campos siguientes son la suma de todos los paquetes binarios generados por el paquete fuente:
EOF
"sourcemax" => <<"EOF");
#<name> es el nombre del paquete fuente;
#
#Los campos siguientes son el maximo de todos los paquetes binarios generados por el paquete fuente:
EOF

# Progress indicator

sub mark
{
  print join(" ",$_[0],times),"\n";
}

# HTML templates

sub htmlheader
{
  print HTML <<"EOH";
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
  <html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
      <title> Canaima Popularity contest </title>
        <link rev="made" href="mailto:ballombe\@debian.org">
        <link rel="shortcut icon" href="/favicon.ico">
        </head>
        <body text="#000000" bgcolor="#E2DAC7" link="#0000FF" vlink="#800080" alink="#FF0000">
        <html>
        <hr color="#916f6f" width="1213" size="5" align="CENTER">
        <table width="100%" cellspacing="0" cellpadding="0" border="0" summary="">
        <tbody>
        <tr>
        <td width="40%" align="center" rowspan="2">
        <a href="http://canaima.softwarelibre.gob.ve/">
        <img height="100" width="200" vspace="0" hspace="0" border="0" src="stat/logo_encuesta_canaima.svg" alt="logo canaima">
        </a>
        </td>
        <td width="60%" align="center">
        <font face="Liberation Sans" color="#452f27" size="4">
        <b>
        <big>Canaima Popularity Contest</big>
        </b>
        </font>
        </td>
        </tr>
        <tr>
        <td height="50%" align="center">
        <form method="GET" action="http://qa.debian.org/popcon.php"> Estad&iacutesticas Popcon para paquete fuente
        <input type="text" name="package" maxlength="80" size="30">
        <input type="submit" value="Go">
        </form>
        </td>
        </tr>
        </tbody>
        </table>
        <hr color="#916f6f" width="1213" size="5" align="CENTER">
EOH
}

sub popconintro
{
  my ($name,$page) = @_;
  &htmlheader;
  print HTML <<"EOF";
  <p><br><em>  El proyecto popularity contest es un intento de asignar el uso de paquetes 
  de Debian. Este sitio publica las estad&iacutesticas recopiladas de informe enviado por los usuarios del paquete
   <a href="http://packages.debian.org/popularity-contest">popularity-contest</a>
  . Este paquete env&iacutea todas las semanas una lista de los paquetes instalados y 
  el tiempo de acceso a los archivos pertinentes al servidor a trav&eacutes de correo electr&oacutenico.
   Todos los d&iacuteas el servidor envuelve el resultado como anonimos y publica esta encuesta.
  Para  m&aacutes informaci&oacuten, consulte el archivo <a href="${docurlbase}README">README</a> y el
  <a href="${docurlbase}FAQ">FAQ</a>.
  </em> <p>
  <br>
  <hr color="#916f6f" width="1213" size="5" align="CENTER">

<style type="text/css">
  #tabs ul { padding: 0; margin: 0; background #916f6f; }
  #tabs li {
    display: inline;
    border: 2px #916f6f solid;
    border-bottom-width: 0;
    margin: 0 2px 0 0;
    font-size: 140%;
    padding: 0 2px;
    -moz-border-radius: 15px 15px 0 0; border-radius: 15px 15px 0 0;
  }
  #tabs #current { background: #916f6f; color: #FFFFFF; }
  #main { border: 2px #916f6f solid; 
  -moz-border-radius: 0 15px 15px 15px; border-radius: 0 15px 15px 15px; }
</style>
<div id="tabs">
  <ul>
EOF
  for (keys %poptext)
  {
    if ($_ eq $name) {
      print HTML "<li id=\"current\">$poptext{$_}</li>\n";
    } else {
      print HTML "<!--<li><a href=\"$popcon{$_}/$page\">$poptext{$_}</a></li>\n-->";
    }
  }
  print HTML <<"EOF";
  </ul>
</div>
<div id="main">
EOF
}

sub htmlfooter
{
  my ($numsub) = @_;
  my $date=gmtime();
  print HTML <<EOF;
<pre>
inst     : n&uacutemero de personas que instalaron este paquete;
vote     : n&uacutemero de personas que utilizan este paquete de forma regular;
old      : n&uacutemero de personas que lo instalaron, pero no lo utilizan este paquete  de forma regular;
recent   : n&uacutemero de personas que actualizaron el paquete recientemente;
no-files : n&uacutemero de personas cuyo ingreso no conten&iacutea suficiente informaci&oacuten;.
</pre>
<p>
N&uacutemero de presentaciones consideradas: $numsub
</p><p>
Para participar en nuestra encuesta, instale el paquete <a href="http://packages.debian.org/popularity-contest">popularity-contest</a> .
</p>
EOF
  print HTML <<EOH
<p>
</div>
<br>
<hr color="#916f6f" width="1213" size="5" align="CENTER">
<p align="center">
Creado por <a href="mailto:ballombe\@debian.org"> Bill Allombert </a>. Ultimo generado on Tue Oct 15 15:50:56 2013 UTC.
<br> <a href="http://popcon.alioth.debian.org"> Popularity-contest project </a> por Avery Pennarun, Bill Allombert y Petter Reinholdtsen.
<br> Fuente original <a href="http://popcon.debian.org"> popcon.debian.org </a>, redise&ntildeado por el equipo de <a href="http://canaima.softwarelibre.gob.ve">Canaima GNU/Linux</a>.
</p>
</body>
</html>
EOH
}

# Report generators

sub make_sec
{
  my $sec="$_[0]/$_[1]";
  -d $sec || system("mkdir","-p","$sec");
  
}

sub print_by
{
   my ($dir,$f)=@_;
   print HTML ("<a href=\"$dir/by_$f\">$f</a> [<a href=\"$dir/by_$f.gz\">gz</a>] ");
}

sub make_by
{
  my ($popcon,$sec,$order,$pkg,$winner,$listp) = @_;
  my (%sum, $me);
  my @list = sort {$pkg->{$b}->{$order}<=> $pkg->{$a}->{$order} || $a cmp $b } @{$listp};
  $winner->{"$sec/$order"}=$list[0];
  open DAT , "|-:utf8", "tee $popcon/$sec/by_$order | gzip -c > $popcon/$sec/by_$order.gz";
  if (defined($list_header{$sec}))
  {
    print DAT $list_header{$sec};
    $me="";
  }
  else 
  {
    print DAT <<"EOF";
#Formato
#   
#<name> es el nombre del paquete;
EOF
    $me="(maintainer)";
  }
  print DAT << "EOF";
#<inst> es el numero de personas que instalaron este paquete;
#<vote> es el numero de personas que utilizan este paquete de forma regular;
#<old>  es el numero de personas que instalaron, pero no utilizan este paquete de forma regular;
#<recent> es el numero de personas que se actualiza el paquete recientemente;
#<no-files> es el numero de personas cuyo ingreso no contenia suficiente informacion;

#rank name                            inst  vote   old recent no-files $me
EOF
  my $format="%-5d %-30s".(" %5d"x($#fields+1))." %-32s\n";
  my $rank=0;
  my $p;
  for $p (@list)
  {
    $rank++;
    my $m=(defined($list_header{$sec})?"":"($maint{$p})");
    printf  DAT $format, $rank, $p, (map {$pkg->{$p}->{$_}} @fields), $m;
    $sum{$_}+=$pkg->{$p}->{$_} for (@fields);
  }
  print  DAT '-'x66,"\n";
  printf DAT $format, $rank, "Total", map {defined($sum{$_})?$sum{$_}:0} @fields, "";
  close DAT;
}

sub make
{
  my ($popcon, $sec,$pkg,$winner,$list)=@_;
  make_sec ($popcon,$sec);
  make_by ($popcon, $sec, $_, $pkg, $winner, $list) for (@fields);
}
sub print_pkg
{
  my ($pkg)=@_;
  return unless (defined($pkg));
  my $size=length $pkg;
  my $pkgt=substr($pkg,0,20);
  print HTML "<a href=\"http://packages.debian.org/$pkg\">$pkgt</a> ",
  ' 'x(20-$size);
}

my %section=();
my %source=();

#Format
#<name> <vote> <old> <recent> <no-files>
#   
#<name> is the package name;
#<vote> is the number of people who use this package regularly;
#<old> is the number of people who installed, but don't use this package
#        regularly;
#<recent> is the number of people who upgraded this package recently;
#<no-files> is the number of people whose entry didn't contain enough
#        information (atime and ctime were 0).

sub read_result
{
  my ($name) = @_;
  my $results = $results{$name};
  my (%pkg,%maintpkg,%sourcepkg,%sourcemax,%arch,$numsub,%release);
  open PKG, "<:utf8","$results" or die "$results not found";
  while(<PKG>)
  {
    my ($type,@values)=split(" ");
    if ($type eq "Package:")
    {
          my @votes = @values;
          my $name = shift @votes;
          unshift @votes,$votes[0]+$votes[1]+$votes[2]+$votes[3];
            $section{$name}='unknown' unless (defined($section{$name}));
            $maint{$name}='Not in sid' unless (defined($maint{$name}));
            $source{$name}='Not in sid' unless (defined($source{$name}));
            for(my $i=0;$i<=$#fields;$i++)
            {
                    my ($f,$v)=($fields[$i],$votes[$i]);
                    $pkg{$name}->{$f}=$v;
                    $maintpkg{$maint{$name}}->{$f}+=$v;
                    $sourcepkg{$source{$name}}->{$f}+=$v;
                    my($sm)=$sourcemax{$source{$name}}->{$f};
                    $sourcemax{$source{$name}}->{$f}=$v 
                      if (!defined($sm) || $sm < $v);
            }
    }
    elsif ($type eq "Architecture:")
    {
      my ($a,$nb)=@values;
      $arch{$a}=$nb;
    }
    elsif ($type eq "Submissions:")
    {
      ($numsub)=@values;
    }
    elsif ($type eq "Release:")
    {
      my ($a,$nb)=@values;
      $release{$a}=$nb;
    }
  }
  close PKG;
  return {'name'      => $name,
          'pkg'       => \%pkg,
          'maintpkg'  => \%maintpkg,
          'sourcepkg' => \%sourcepkg,
          'sourcemax' => \%sourcemax,
          'arch'      => \%arch,
          'release'   => \%release,
          'numsub'    => $numsub};
}

sub gen_sections
{
  my ($stat) = @_;
  my $name = $stat->{'name'};
  my %pkg = %{$stat->{'pkg'}};
  my %maintpkg = %{$stat->{'maintpkg'}};
  my %sourcepkg = %{$stat->{'sourcepkg'}};
  my %sourcemax = %{$stat->{'sourcemax'}};
  my %arch = %{$stat->{'arch'}};
  my %release = %{$stat->{'release'}};
  my $numsub = $stat->{'numsub'};
  my $popcon = "$popbase$popcon{$name}";
  my $popfile = $popfile{$name};
  my @pkgs=sort keys %pkg;
  my %sections = map {$section{$_} => 1} keys %section;
  my @sections = sort keys %sections;
  my @maints= sort keys %maintpkg;
  my @sources= sort keys %sourcepkg;
  my %winner = ();
  my ($sec, $dir, $f);
  for $sec (@sections)
  {
    my @list = grep {$section{$_} eq $sec} @pkgs;
    make ($popcon, $sec, \%pkg, \%winner, \@list);
  }
  #There is a hack: '.' is both the current directory and
  #the catchall regexp.
  for $sec (".",@dists)
  {
    my @list = grep {$section{$_} =~ /^$sec/ } @pkgs;
    make ($popcon, $sec, \%pkg, \%winner, \@list);
  }
  make ($popcon, "maint", \%maintpkg, \%winner, \@maints);
  make ($popcon, "source", \%sourcepkg, \%winner, \@sources);
  make ($popcon, "sourcemax", \%sourcemax, \%winner, \@sources);

  for $sec (@dists)
  {
    open HTML , ">:utf8", "$popcon/$sec/index.html";
    opendir SEC,"$popcon/$sec";
    popconintro($name,"$sec/index.html");
    printf HTML ("<p>Statistics for the section %-16s sorted by fields: ",$sec);
    print_by (".",$_) for (@fields);
    print HTML ("\n </p> \n");
    printf HTML ("<p> <a href=\"first.html\"> First packages in subsections for each fields </a>\n");
    printf HTML ("<p>Statistics for subsections sorted by fields\n <pre>\n");
    for $dir (sort readdir SEC)
    {
      -d "$popcon/$sec/$dir" or next;
      $dir !~ /^\./ or next;
      printf HTML ("%-16s : ",$dir);
      print_by ($dir,$_) for (@fields);
      print HTML ("\n");
    }
    print HTML ("\n </pre>\n");
    htmlfooter $numsub;
    closedir SEC;
    close HTML;
  }
  for $sec (@dists)
  {
    open HTML , ">:utf8", "$popcon/$sec/first.html";
    opendir SEC,"$popcon/$sec";
    popconintro($name,"$sec/first.html");
    printf HTML ("<p>First package in section %-16s for fields: ",$sec);
    for $f (@fields)
    {
            print_pkg $winner{"$sec/$f"};
    }
    print HTML ("\n </p> \n");
    printf HTML ("<p> <a href=\"index.html\"> Statistics by subsections sorted by fields </a>\n");
    printf HTML ("<p>First package in subsections for fields\n <pre>\n");
    printf HTML ("%-16s : ","subsection");
    for $f (@fields)
    {
            printf HTML ("%-20s ",$f);
    }
    print HTML ("\n","_"x120,"\n");
    for $dir (sort readdir SEC)
    {
            -d "$popcon/$sec/$dir" or next;
            $dir !~ /^\./ or next;
            printf HTML ("%-16s : ",$dir);
            for $f (@fields)
            {
                    print_pkg $winner{"$sec/$dir/$f"};
            }
            print HTML ("\n");
    }
    print HTML ("\n </pre>\n");
    htmlfooter $numsub;
    closedir SEC;
    close HTML;
  }
  open HTML , ">:utf8", "$popcon/index.html";
  popconintro($name,"index.html");
  printf HTML ("<p>Estad&iacutesticas de todo el archivo, ordenados por campos: <pre>");
  print_by (".",$_) for (@fields);
  print HTML ("</pre>\n </p> \n");
  printf HTML ("<p>Estad&iacutesticas de todo los mantenedores, ordenados por campos: <pre>");
  print_by ("maint",$_) for (@fields);
  print HTML ("</pre>\n </p> \n");
  printf HTML ("<p>Estad&iacutesticas de todos los paquetes fuente(sum), ordenados por campos: <pre>");
  print_by ("source",$_) for (@fields);
  print HTML ("</pre>\n </p> \n");
  printf HTML ("<p>Estad&iacutesticas de todos los paquetes fuente(maximo), ordenados por campos: <pre>");
  print_by ("sourcemax",$_) for (@fields);
  print HTML ("</pre>\n </p> \n");
  printf HTML ("<p>Estad&iacutesticas de secciones ordenadas\n <pre>\n");
  for $dir ("main","contrib","non-free","non-US","unknown")
  {
    -d "$popcon/$dir" or next;
    $dir !~ /^\./ or next;
    if ($dir eq "unknown")
    {
      printf HTML ("%-16s : ",$dir);
    }
    else
    {
      printf HTML ("<a href=\"$dir/index.html\">%-16s</a> : ",$dir);
    }
    print_by ($dir,$_) for (@fields);
    print HTML ("\n");
  }
  print HTML  <<'EOF';
</pre>
<table border="0" cellpadding="5" cellspacing="0" width="100%">
<tr>
<td>
Estad&iacutesticas por arquitectura:
<pre>
EOF
    for $f (grep { $_ ne 'unknown' } sort keys %arch)
    {
      my ($port)=split('-',$f);
      $port="$port/";
      $port="kfreebsd-gnu/" if ($port eq "kfreebsd/");
      printf HTML "<a href=\"http://www.debian.org/ports/$port\">%-16s</a> : %-10s <a href=\"stat/sub-$f.png\">graph</a>\n",$f,$arch{$f};
    }
  if (defined $arch{"unknown"}) {
    printf HTML "%-16s : %-10s <a href=\"stat/sub-unknown.png\">graph</a>\n","unknown",$arch{"unknown"}
  }
  print HTML "</pre></td>\n";
  print HTML  <<'EOF';
<td>
<table>
  <tr><td>
    <img alt="Graph of number of submissions per architectures"
    width="600" height="400" src="stat/submission.png">
  </td></tr>
  <tr><td>
    <img alt="Graph of number of submissions per architectures (last 12 months)"
    width="600" height="400" src="stat/submission-1year.png">
  </td></tr>
</table>
</td>
EOF
  print HTML  <<'EOF';
</tr><tr><td>
Estad&iacutesticas por versiones  de popularity-contest:
<pre>
EOF
    for $f (grep { $_ ne 'unknown' } sort keys %release)
    {
      my($name) = $f;
      $name = "$f ($popconver{$f})" if (defined($popconver{$f}));
      printf HTML "%-25s : %-10s \n",$name,$release{$f};
    }
  if (defined $release{"unknown"}) {
    printf HTML "%-25s : %-10s \n","unknown",$release{"unknown"};
  }
  print HTML "</pre></td>\n";
  print HTML  <<'EOF';
<td>
  <table>
    <tr><td>
      <img alt="Graph of popularity-contest versions in use"
       width="600" height="400" src="stat/release.png">
    </td></tr>
    <tr><td>
      <img alt="Graph of popularity-contest versions in use (12 last months)"
       width="600" height="400" src="stat/release-1year.png">
    </td></tr>
  </table>
</td>
EOF
  print HTML "</tr></table><p>\n";
  print HTML "<a href=\"$popfile\">Popularity-contest resultados completos </a>\n";
  htmlfooter $numsub;
  close HTML;
}

sub read_packages
{
  my ($file,$dist);
  for $file ("slink","slink-nonUS","potato","potato-nonUS",
      "woody","woody-nonUS","sarge","etch")
  {
    open AVAIL, "<:utf8", "$file.sections" or die "Cannot open $file.sections";
    while(<AVAIL>)
    {
      my ($p,$sec)=split(' ');
      defined($sec) or last;
      chomp $sec;
      $sec =~ m{^(non-US|contrib|non-free)/} or $sec="main/$sec";
      $section{$p}=$sec;
      $maint{$p}="Not in sid";
      $source{$p}="Not in sid";
    }
    close AVAIL;
  }
  mark "Reading legacy packages...";
  for $dist ("stable", "testing", "unstable")
  {
    for (glob("$mirrorbase/dists/$dist/*/binary-*/Packages.gz"))
    {
      /([^[:space:]]+)/ or die("incorrect package name");
      my $file = $1;#Untaint
        open AVAIL, "-|:encoding(UTF-8)","zcat $file";
      my $p;
      while(<AVAIL>)
      {
        /^Package: (.+)/  and do {$p=$1;$maint{$p}="bug";$source{$p}=$p;next;};
        /^Version: (.+)/ && $p eq "popularity-contest" 
          and do { $popver{$dist}=$1; next;};
        /^Maintainer: ([^()]+) (\(.+\) )*<.+>/
          and do { $maint{$p}=join(' ',map{ucfirst($_)} split(' ',lc $1));next;};
        /^Source: (\S+)/ and do { $source{$p}=$1;next;};
        /^Section: (.+)/ or next;
        my $sec = $1;
        $sec =~ m{^(non-US|contrib|non-free)/} or $sec="main/$sec";
        $section{$p}=$sec;
      }
      close AVAIL;
    }
  }
  mark "Reading current packages...";
  for $dist ("stable", "testing", "unstable")
  {
    my($v)=$popver{$dist};
    $popconver{$v}=defined($popconver{$v})?"$popconver{$v}/$dist":$dist;
  }
}

# Main code

read_packages();

mark "Reading packages...";

my %stat = ('all' => read_result('all'),
            'stable' => read_result('stable'));

mark "Reading stats...";

for (keys %stat)
{
  gen_sections($stat{$_});
}

mark "Building pages";
