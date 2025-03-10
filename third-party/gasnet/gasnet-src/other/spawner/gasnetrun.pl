#!/usr/bin/env perl
#   $Source: bitbucket.org:berkeleylab/gasnet.git/ibv-conduit/contrib/gasnetrun_ibv.pl $
# Description: GASNet spawner script for ibv-conduit and several other conduits
# Terms of use are as specified in license.txt

require 5.004;
use strict;
use Fcntl;
use IO::File;
use Cwd qw(cwd);
BEGIN {
  eval 'use File::Temp qw(:POSIX);';
  eval 'use POSIX qw(tmpnam);' if $!;
  die if $!;
}

# Globals
my @mpi_args = ();
my $numproc = undef;
my $numnode = undef;
my $restart = 0;
my $verbose = 0;
my $keep = 0;
my $dryrun = 0;
my $exebase = undef;
my $exepath = undef;
my $exeindex = undef;
my $envlist = undef;
my $nodefile = $ENV{'GASNET_NODEFILE'} || $ENV{'PBS_NODEFILE'};
my @tmpfiles = (defined($nodefile) && $ENV{'GASNET_RM_NODEFILE'}) ? ("$nodefile") : ();
my $conduit = $ENV{'GASNET_SPAWN_CONDUIT'};
my $spawner_var = 'GASNET_' . $conduit . '_SPAWNER';
my $spawner = $ENV{$spawner_var};
my $pshm_enabled = $ENV{'GASNET_PSHM_ENABLED'} eq 'yes';

sub usage
{
    print (@_) if (@_);

    my @spawners = ();
    push (@spawners,'fork') if ($ENV{'GASNET_SPAWN_HAVE_FORK'});
    push (@spawners,'ssh')  if ($ENV{'GASNET_SPAWN_HAVE_SSH'});
    push (@spawners,'mpi')  if ($ENV{'GASNET_SPAWN_HAVE_MPI'});
    push (@spawners,'pmi')  if ($ENV{'GASNET_SPAWN_HAVE_PMI'});

    print "usage: gasnetrun_".lc($conduit)." -n <n> [options] [--] prog [program args]\n";
    print "    options:\n";
    print "      -n <n>                 number of processes to run\n";
    print "      -N <N>                 number of nodes to run on (not always supported)\n"
          unless ($conduit eq 'SMP');
    print "      -c <n>                 number of cpus per process (not always supported)\n";
    print "      -E <VAR1[,VAR2...]>    list of environment vars to propagate\n";
    print "      -v                     enable verbose output, repeated use increases verbosity\n";
    print "      -t                     test only, don't execute anything (implies -v)\n";
    print "      -k                     keep any temporary files created (implies -v)\n";
    print "      -spawner=<name>        force use of a specific spawner (".join('|', @spawners).")\n" if (@spawners > 1);
    print "      --                     ends option parsing\n";
    exit 1;
}

sub fullpath($)
{
    my $file = shift;
    my $result = undef;
    if ($file =~ m|^/|) {
	# full path, don't do anything to it
	$result = $file;
    } elsif ($file =~ m|/| || -x $file) {
	# has directory components or exists in cwd
	$result = cwd() . "/$file";
    } else {
	# search PATH
	foreach (split(':', $ENV{PATH})) {
	    my $tmp = "$_/$file";
	    if (-x $tmp) {
		$result = $tmp;
		last;
	    }
	}
    }
    return $result
}

# We need to parse our command-line arguments
# We also build up @mpi_args, stripping out ones that are purely ours
   
    while (@ARGV > 0) {
	$_ = $ARGV[0];
	push @mpi_args, $_;

	if ($_ eq '--') {
	    shift;
	    last;
	} elsif ($_ eq '-n' || $_ eq '-np') {
	    shift;
	    push @mpi_args, $ARGV[0];
	    usage ("$_ option given without an argument\n") unless @ARGV >= 1;
	    $numproc = 0+$ARGV[0];
	    usage ("$_ option with invalid argument '$ARGV[0]'\n") unless $numproc >= 1;
	} elsif ($_ =~ /^(-np?)([0-9]+)$/) {
	    $numproc = 0+$2;
	    usage ("$1 option with invalid argument '$2'\n") unless $numproc >= 1;
	} elsif ($_ eq '-N') {
	    shift;
	    push @mpi_args, $ARGV[0];
	    usage ("$_ option given without an argument\n") unless @ARGV >= 1;
	    $numnode = 0+$ARGV[0];
	    usage ("$_ option with invalid argument '$ARGV[0]'\n") unless $numnode >= 1;
	} elsif ($_ eq '-c') {
	    shift;
	    push @mpi_args, $ARGV[0];
	    usage ("$_ option given without an argument\n") unless @ARGV >= 1;
	    usage ("$_ option with invalid argument '$ARGV[0]'\n") unless ($ARGV[0] =~ m/^[0-9]+$/);
	} elsif ($_ =~ /^(-c)([0-9]+)$/) {
            # nothing to do
	} elsif ($_ =~ /^(-N)([0-9]+)$/) {
	    $numnode = 0+$2;
	    usage ("$1 option with invalid argument '$2'\n") unless $numnode >= 1;
	} elsif ($_ eq '-E') {
	    shift;
	    push @mpi_args, $ARGV[0];
	    $envlist = $ARGV[0];
	    usage ("-E option given without an argument\n") unless @ARGV >= 1;
	} elsif ($_ =~ /^-spawner=(.+)$/) {
	    $spawner = $1;
	    pop @mpi_args;	# not known to mpi/pmi spawner
	} elsif ($_ eq '-restart') {
	    shift;
	    $restart = 1;
	    pop @mpi_args;	# not known to mpi/pmi spawner
	    usage "-restart option given without an argument\n" unless @ARGV >= 1;
	    last;
	} elsif ($_ eq '-v') {
	    $verbose++;
	} elsif ($_ eq '-t') {
	    $dryrun = 1;
	    $verbose = 1 if (!$verbose);
	} elsif ($_ eq '-k') {
	    $keep = 1;
	    $verbose = 1 if (!$verbose);
	} elsif (m/^-/) {
	    usage ("unrecognized option '$_'\n");
	} else {
	    pop @mpi_args; # pop off program name
	    last;
	}
	shift;
    }

# Validate spawner
    if (!defined($spawner)) {
        usage "Option -spawner was not given and no default is set\n"
    }
    $ENV{$spawner_var} = lc($spawner);
    $spawner = uc($spawner);
    if ($spawner eq 'MPI') {
        usage "Spawner is set to MPI, but MPI support was not compiled in\n"
            unless $ENV{'GASNET_SPAWN_HAVE_MPI'};
    }
    elsif ($spawner eq 'PMI') {
        usage "Spawner is set to PMI, but PMI support was not compiled in\n"
            unless $ENV{'GASNET_SPAWN_HAVE_PMI'};
    }
    elsif ($spawner eq 'FORK') {
        usage "Spawner is set to FORK, which is not valid for ".lc($conduit)."-conduit\n"
            unless ($conduit eq 'SMP');
    }

# Restart-specific options processing
    if ($restart) {
        usage "Option -n cannot be specified with -restart\n" if defined($numproc);
        usage "Option -E cannot be specified with -restart\n" if defined($envlist);
        usage "Spawner $spawner does not implement -restart\n"
            unless grep(/$spawner/, qw/SSH/);
        my $dir = $ARGV[-1];
        die "gasnetrun: restart argument '$dir' does not exist\n"
            unless -e $dir;
        die "gasnetrun: restart argument '$dir' is not a directory\n"
            unless -d $dir;
        die "gasnetrun: restart argument '$dir' is not accessible\n"
            unless -x $dir;
        my $found = 0;
        open (FILE, "$dir/metadata");
        while (<FILE>) {
            if (/argv0:\s*(\S+)/) {
                splice(@ARGV,-1,0,$1);
                $found |= 1;
            } elsif (/nproc:\s*(\S+)/) {
                $numproc = $1;
                $found |= 2;
           }
        }
        close FILE;
        die "gasnetrun: '$dir' is not a valid restart directory\n"
            unless $found == 3;
        $ARGV[-1] = (cwd() . '/' . $dir) unless ($dir =~ m|^/|);
    }

# Validate/default -n as needed
    if (($conduit eq 'SMP') && ! $pshm_enabled) {
        if (!defined $numproc) {
            $numproc = 1;
        } elsif ($numproc != 1) {
            die "gasnetrun: smp-conduit without PSHM only supports '-n 1'\n";
        }
    } elsif (!defined $numproc) {
        usage "Required option -n was not given\n";
    }

# Validate/default -N as needed
    if ($conduit eq 'SMP') {
        if (!defined $numnode) {
            $numnode = 1;
        } elsif ($numnode != 1) {
            die "gasnetrun: smp-conduit only supports '-N 1'\n";
        }
    }

# Implement -E for ssh, if required, as a wrapper (processed below)
    if (($spawner eq 'SSH') && defined $envlist) {
        foreach (split(',', $envlist)) {
            # Screen both variable names and values for "bad" ones.
            # See Bug 4723 for the motivation.
            next if ($ENV{$_} =~ m/\n/); # skip value with newline(s), which we cannot portably quote
            next unless ($_ =~ m/^[A-Za-z_][A-Za-z0-9_]*$/); # skip invalid variable name

            unshift @ARGV, "$_=$ENV{$_}";
        }
        unshift @ARGV, $ENV{'GASNET_ENVCMD'};
    }

# Find the program (possibly a wrapper)
    $exebase = $ARGV[0] or usage "No program specified\n";
    $exepath = fullpath($exebase);
    die "gasnetrun: unable to locate program '$exebase'\n" unless (defined($exepath) && -e $exepath);
    print "gasnetrun: located executable '$exepath'\n" if ($verbose);
    die "gasnetrun: missing execute permissions for '$exepath'\n" unless -x $exepath;
    $ARGV[0] = $exepath;

# Bug 3578:
if (($conduit eq 'IBV') && !exists($ENV{'OMPI_MCA_mpi_warn_on_fork'})) {
  $ENV{'OMPI_MCA_mpi_warn_on_fork'} = 0;
}

# Find the GASNet executable and verify its capabilities
    my $pattern = "^GASNet" . $spawner . "Spawner: 1 \\\$";
    my $found = undef;
    $exeindex = 0;
    foreach my $arg (@ARGV) {
	++$exeindex;
	next if ($arg =~ m/^-/); # skip obvious options
	my $file = fullpath($arg);
	next unless (defined($file) && -x $file); # not found or not executable
        my $is_gasnet = undef;
	next unless open (FILE, $file);
	{   local $/ = '$'; # use $ as the line break symbol
            while (<FILE>) {
                next unless(/^GASNet/);
		if (/GASNetConduitName: $conduit \$/o) { $is_gasnet = 1; next; }
                if (/$pattern/o) { $found = 1; last; }
            }
        }
        close (FILE);
	if ($found) {
	    if ($exeindex > 1) { # wrapper in use
		$arg = $file;	# canonicalize (foreach is by reference)
		print "gasnetrun: located GASNet executable '$file'\n" if ($verbose);
	    }
	    last;
	} elsif ($is_gasnet) {
	    die "GASNet executable '$file' does not support spawner '$spawner'\n";
	}
    }
    if (!$found) {
      warn "gasnetrun: unable to locate a GASNet program in '@ARGV'\n";
      $exeindex = 1;  # hope for the best!
    }

# Run it which ever way makes sense
    if ($verbose >= 1) {
      $ENV{"GASNET_VERBOSEENV"} = "1" unless (exists($ENV{"GASNET_VERBOSEENV"}));
    }
    if ($verbose >= 2) {
      $ENV{"GASNET_SPAWN_VERBOSE"} = "1" unless (exists($ENV{"GASNET_SPAWN_VERBOSE"}));
    }
    if ($spawner eq 'MPI' || $spawner eq 'PMI') {
        print("gasnetrun: forwarding to $spawner-based spawner\n") if ($verbose);
        @ARGV = (@mpi_args, @ARGV);
        (my $mpi = $0) =~ s/\.pl$/-mpi.pl/;
        die "cannot find $mpi: $!" unless -f $mpi;
        my $err = do $mpi; # use 'do' to load another perl file (reduce forks, etc)
        if ($@ || $err) {
          die "error running $mpi:\n $@ $err\n";
        }
    } elsif ($spawner eq 'FORK') {
        unshift(@ARGV, $ENV{'GASNET_ENVCMD'}, "GASNET_PSHM_NODES=$numproc");
        print("gasnetrun: running: ", join(' ', @ARGV), "\n") if ($verbose);
        unless ($dryrun) { exec(@ARGV) or die "failed to exec $exebase\n"; }
    } elsif ($spawner eq 'SSH') {
	my $wrapper = ($exeindex > 1) ? join ' ',
					     map { s/'/'\\''/g; "'".$_."'"; }
						 splice @ARGV, 0, $exeindex-1
				      : undef;
        my $fh;
        my $fileno = -1;
        { # Create an unlinked temp file containing the entire command line
          my $filename;
          do { $filename = tmpnam(); }
            until $fh = IO::File->new($filename, O_RDWR|O_CREAT|O_EXCL, 0600);
          unlink($filename);
          binmode($fh);
          my $flags = fcntl($fh, F_GETFD, 0) or die "fcntl F_GETFD: $!";
          fcntl($fh, F_SETFD, $flags & ~FD_CLOEXEC) or die "fcntl F_SETFD: $!";
          foreach (@ARGV) {
            syswrite($fh, $_);
            syswrite($fh, chr(0));
          }
          sysseek($fh, 0, SEEK_SET);
          $fileno = fileno($fh);
        }
        $ENV{'GASNET_SPAWN_ARGS'} = join(',', (($restart?'R':'M').($verbose >= 2?'v':'')),
                                         $fileno, $numproc, $numnode, $wrapper);
        print("gasnetrun: set GASNET_SPAWN_ARGS=|$ENV{GASNET_SPAWN_ARGS}|\n") if ($verbose);
        print("gasnetrun: running: ", join(' ', @ARGV), "\n") if ($verbose);
        unless ($dryrun) { exec(@ARGV) or die "failed to exec $exebase\n"; }
    } else {
        die "Unknown spawner '$spawner' requested\n";
    }

__END__
