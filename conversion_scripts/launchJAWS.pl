#! /usr/csite/pubtools/bin/perl

#This script is used to execute the correct "makeALHConfig" script.

use strict;
use Getopt::Long;

#script options:
my ($system,$type,$reqfilename,$update,$classes,$jaws);
$update = 0;
GetOptions("system:s" => \$system,
           'filename:s' => \$reqfilename,
           'update' => \$update,
           'classes' => \$classes,
           'jaws' => \$jaws);


#If neither "jaws" nor "classes" 
#Excute both.
my @typelist;
if ($jaws) {
   push(@typelist,"jaws");
} 
if ($classes) {
   push(@typelist,"classes");
}
if (!scalar(@typelist)) {
   @typelist = qw(jaws classes);
}

if (!$system) {
   print("FORGOT SYSTEM\n");
   exit;
}

my $lcsystem = lc($system);
#Iterate through the types (jaws/classes)
foreach my $type (@typelist) {
   my $filename;
   my $classfile;
   
   #Add to the CLASSES.jaws file (comprehensive list)
   #Also create a system specific class file.
   if ($type eq "classes" && $update && !$reqfilename)  {    
      $filename = "JAWS/CLASSES.jaws";
      
      $classfile = "JAWS/$lcsystem.classes";
   
   } elsif ($type eq "jaws" && $update) {
      $filename = "JAWS/$lcsystem"
   }
   
   #The alhConfig script to run 
   my $script = "new${system}Config.pl";
   if (!-e $script) {
      print("NO SCRIPT FOR $system : $script\n");
      exit;
   }
   #Script types -type and -filename argument.
   #If script updates filename if passed.
   my $command = "$script -$type";
   if ($filename) {
      $command = "$command -filename=$filename";
     
   } 
   #Execute the command;  
   system($command);
   my $command = "$script -$type";
   
   #If a classfile exists (if type = "classes")
   if ($classfile) {
      #Execute the command again. 
      $command = "$command -filename=$classfile";
      system("$command");
   }
   
}

