#!/usr/bin/perl

( -d "scripts" ) || die "ERROR: please run this from the project root!\n\n";

( -d "build" ) || die "ERROR: cannot find build directory with binaries!\n\n";

mkdir "dist" if ( ! -e "dist" );

$xz = `which xz`; chomp $xz;
if ( $xz eq '' ) {
   $arch = `uname -m`; chomp $arch;
   if ( -x "/opt/R/$arch/bin/xz" ) {
      $xz = "/opt/R/$arch/bin/xz";
   } elsif ( -x "/usr/local/bin/xz" ) {
      $xz = "/usr/local/bin/xz";
   } else {
      die "ERROR: cannot find xz to re-compress binary tar balls!";
   } 
}

@a = <build/*.tar.gz>;

open OUT, ">dist/PACKAGES";
foreach $fn (@a) {
   $pkg = $fn;
   $pkg =~ s/.*\///;
   $pkg =~ s/-darwin.*.tar.gz$//;

   $dep = ''; $name = '';
   if ( -e "build/$pkg" ) {
         open IN, "build/$pkg";
         while (<IN>) {
            if (/^Package:/) {
               chomp;
               s/^Package: *//;
               $name = $_;
            }
         }
         close IN;
         ( $name ne '') || die "ERROR: receipt $pkg does not include package name!\n"; 
         ( -e "recipes/$name" ) || die "ERROR: cannot find recipe for $name!\n";
         open IN, "recipes/$name";
         while (<IN>) {
            $dep .= $_ if (/^(Depends|Suggest)/);
         }
         my $xfn = $fn;
         $xfn =~ s/.*\//dist\//;
         $xfn =~ s/\.tar\.gz/.tar.xz/;
         ($atime, $mtime) = (stat($fn))[8,9];
         ($xmtime) = (stat($xfn))[9];
         if ( -e $xfn && $xmtime == $mtime) {
            print "$fn has not changed, skipping re-compression\n";
         } else {
            print "Re-compressing $fn -> $xfn\n";
            system("$xz -c9 < '$fn' > '$xfn'") == 0 || die("Cannot re-compress!");
            system("ls -l $fn");
            ($atime, $mtime) = (stat($fn))[8,9];
            utime($atime, $mtime, $xfn);
            system("ls -l $xfn");
         }
         $out = '';
         open IN, "build/$pkg";
         while (<IN>) {
            s/\.tar\.gz/.tar.xz/g;
            $_ = '' if (/^BuiltWith: *$/);
            $out .= (/^Depend/) ? $dep : $_;
         }
         close IN;
         print OUT $out;
   } else {
         print STDERR "WARNING: $fn ($name) has no recipe\n";
   }
}
close OUT;

