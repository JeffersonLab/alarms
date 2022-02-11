package alhJAWSUtils;
require Exporter;


use strict;

#use JLAB;
our @ISA = qw(Exporter);
our @EXPORT = qw(Trim getSubAreaList inList system createJAWSDef deleteExistingJAWS
   findParentArea printJAWSDef);

use alhUtils;

our $system;

our %regions = (
  'INJECTOR' => ["INJ-I","INJ-L","INJ-R","1D_SPECTROMETER","2D_SPECTROMETER","3D_MOTT",
                 "5D_SPECTROMETER","4D_SPECTROMETER"],
  'NORTH_LINAC' => ["LINAC1", "LINAC3", "LINAC5", "LINAC7", "LINAC9", "LINACB"],
  'SOUTH_LINAC' => ["LINAC2", "LINAC4", "LINAC6", "LINAC8", "LINACA"],
  'EAST_ARC' => ["ARC1", "ARC3", "ARC5", "ARC7", "ARC9"],
  'WEST_ARC' => ["ARC2", "ARC4", "ARC6", "ARC8", "ARCA"],
  'BSY' => ["BSY2", "BSY4", "BSY6", "BSY8", "BSYA"],
  'LERF' => ["0F","1F","2F","3F","4F","5F","1G"],
 
  
);
  
our %subareas = (
   ACC => ["MCC", "NORTH_LINAC", "SOUTH_LINAC", "EAST_ARC", "WEST_ARC", "BSY_DUMP", "BSY", "CHL"],
  'LERF' => ["0F","1F","2F","3F","4F","5F","1G"],
 

);
our %segmaskmap = (
  ACC => "A_MCC+A_NorthLinac+A_SouthLinac+A_EastArc+A_WestArc+A_BSY+A_CHL"
);
  
our %cedmap = (
   ACC => "Accelerator",
   INJECTOR => "Injector",
   NORTH_LINAC => "NorthLinac",
   SOUTH_LINAC => "SouthLinac",
   EAST_ARC => "EastArc",
   WEST_ARC => "WestArc",
   HALLA => "HallA",
   HALLB => "HallB",
   HALLC => "HallC",
   HALLD => "HallD",
   BSY => "BSY",
   CHL => "CHL",
   FEL => "FEL",
   MCC => "MCC",
   LERF => "LERF",
   UITF => "UITF"
   
);
sub findParentArea {
  my $subarea = $_[0];
  my %reverse = reverse(%subareas);
  my $area;
  foreach my $key (keys (%subareas)) {
    
    if (inList($subarea,$subareas{$key})) {
      $area = $key;
    }
   
  }
  #If not a list of subareas, try regions
  if (!$area) {
    foreach my $key (keys (%regions)) {
      if (inList($subarea,$regions{$key})) {
        $area = $key;
      }
    }
  }
  return($area);
   
}


#get the list of subareas for the area.
sub getSubAreaList {
  my $area = $_[0];
  #expand the list of areas to include subareas 
  my @subareas = $area;
  if (exists($subareas{$area})) {
    @subareas = @{$subareas{$area}};
   
  } 
  return(\@subareas);
}



sub printJAWSDef {
   my $def = $_[0];
   my $filename = $_[1];
   
   if ($filename) {
      
      open(CLASSFILE,">> $filename");
      print CLASSFILE "$def\n";
      close(CLASSFILE);
   } else {
      print("$def\n");
   }
   return;  
}

sub createJAWSDef {
   my $jawsobj = $_[0];
   my $params = $_[1];
   
   my @stringvars = qw(category correctiveaction maskedby pointofcontactusername
      class maskedby screencommand);
   
   my @listvars = qw(location);
   
   my $name = Trim($jawsobj->{'name'});
   
   my $comma = 0;
   my $def = "$name={";
   
   foreach my $param (@$params) {
      
      if ($comma) {
         $def = $def . ", ";
      }
      
      my $value = $jawsobj->{$param};
      if (!$value) {
         $value = "null";
      }
      if ($value ne "null") {
         if (inList($param,\@stringvars)) {
            $value = "\"$value\"";                
         } elsif (inList($param,\@listvars)) {
            $value = "\[\"$value\"\]";
         }
      }  
      
      $def = $def . "\"$param\": $value";      
      $comma = 1;
      
   }
   $def = $def . "\}"; 

   return($def);

 
}
   

sub deleteExistingJAWS {
   my $filename = $_[0];
   
   if (-e $filename) {
      unlink($filename);
   }
}


## @fn string Trim(@string)
# @brief Remove the leading and trailing whitespace from a string or list of
# strings.
#
# Subroutine stolen from Theo Larrieu. Pass in a string or list of strings
# and it will trim leading and trailing whitespace and return the result.
# @param string the string or list of strings to trim
# @returns trimmed string or list of strings.
sub Trim {
    my @out = @_;
    for (@out) {
        s/^\s+//;
        s/\s+$//;
    }
    return wantarray ? @out : $out[0];
}

## @fn boolean inList($entry, ref @listref)
# @brief Check if an entry is found in a list
# @param entry the entry to look for
# @param listref a reference to the list to look in
# @returns 1, if entry is in list, or 0, if not.
sub inList {
   my $entry = shift;
	my $listref = $_[0];
	#grep for the entry in the list
	if (grep {/^$entry\b/} (@$listref)) {
		return 1;
	} 
	return 0;
	
}