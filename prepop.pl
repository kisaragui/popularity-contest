#!/usr/bin/perl 
# Accept popularity-contest entries on stdin and drop them into a
# subdirectory with a name based on their MD5 ID.
#
# Only the most recent entry with a given MD5 ID is kept.
#

$dirname = '/var/lib/popcon/bin/popcon-entries';
$now = time;
$state='initial'; # one of ('initial','accept','reject')
#open(REPORTE2, '>>reporte2.txt');
#print REPORTE2 "entra a prepop.pl\n";

print "ENTRO A PREPOP.PL\n";

$i = 0;

my($file,$mtime);
while(<>)
{
	#print "$i: $_\n";
	#$i = $i + 1;

    $state eq 'initial' and do
    {
       /^POPULARITY-CONTEST-0/ or next;
       my @line=split(/ +/);
       my %field;
       for (@line)
       {
	    my ($key, $value) = split(':', $_, 2);
            $field{$key}=$value;
            
       };
       $id=$field{'ID'};
	print "IDPP: $id\n";
       if (!defined($id) || $id !~ /^([a-f0-9]{32})$/) 
       {
         print STDERR "Bad hostid: $id\n";
         $state='reject';print "entrando en estado REJECT ID (1)\n"; next;
       }
       $id=$1; #untaint $id
       
       $mtime=$field{'TIME'};
       if (!defined($mtime) || $mtime!~/^([0-9]+)$/)
       {
         print STDERR "Bad mtime $mtime\n";
         $state='reject';print "entrando en estado REJECT MTIME (2)\n"; next;
       }
       $mtime=int $1; #untaint $mtime;
       $mtime=$now if ($mtime > $now);
       my $dir=substr($id,0,2);
	print "DIRPP: $dir\n";
       unless (-d "$dirname/$dir") { 

	mkdir("$dirname/$dir",0755) or do {$state='reject';print "entrando en estado REJECT no puede crear carpeta (3)\n"; next;}
;
       };
       $file="$dirname/$dir/$id"; 
	print "FILEPP: $file\n";
	open REPORT, ">",$file or do {$state='reject';print "entrando en estado REJECT NO copio el informe (4)\n";next;};
       print REPORT $_;
       $state='accept'; next;
    };
    $state eq 'reject' and do
    {
      /^From/ or next;
      $state='initial';next;
    };
    $state eq 'accept' and do
    {
      /^From/ and do 
      {
        close REPORT; 
        unlink $file; 
        print STDERR "Bad report $file\n";
        $state='initial';
        next;
      };
      print REPORT $_; #accept line.
      /^END-POPULARITY-CONTEST-0/ and do 
      {
        close REPORT; 
        utime $mtime, $mtime, $file;
        $state='initial';
        next;
      };
    };
}
if ($state eq 'accept')
{
        close REPORT;
        unlink $file; #Reject
        print STDERR "Bad last report $file\n";
}

print "SALE DE PREPOP.PL\n";
