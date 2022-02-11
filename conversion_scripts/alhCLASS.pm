package alhCLASS;

use strict;
use alhJAWSUtils;

our @ISA = qw(Exporter);
our @EXPORT = qw(writeClasses);


#Collection of JAWS classes
my %classhash;


## Called by the alhConfig script
# @param alarmhash - hash of JAWS alarms system
# @param filename - output file (optional)
# @details The alhConfig hash contains all of the alarms
#  for the system.
sub writeClasses {
   my $alarmhash = $_[0];
   my $filename = $_[1]; 
   
   #We only need one example of each class.
   #keep track of the alarm names (for duplicates)
   my @names;
   
   #The final list of classes
   my @finallist; 
   foreach my $key (keys(%$alarmhash)) {
      my $alarm = $alarmhash->{$key};
      my $classname = $alarm->{'class'};      
      if (!$classname) {
         next;
      } 
      #Create a class with the JAWS alarm
      my $class = new alhCLASS($alarm,$filename);
      %classhash->{$classname} = $class;
   }
   
   #Print each class   
   my @classlist = keys(%classhash);
   foreach my $classname (sort(@classlist)) {      
      my $class = %classhash->{$classname};      
      my $paramlist = $class->{'paramlist'};
      my $def = createJAWSDef($class,$paramlist);
      printJAWSDef($def,$filename);
   }
   
   #These new classes need to be alphabetically integrated with the classes
   #of the other systems. 
   addCLASSList($filename);
}


## Create a new JAWS class
#  @param alarm    - JAWS alarm (optional)
#  @param filename - output file (optional)
#  @param %params  - hash of overridden class properties
sub new {
   my $class = shift;
   my $alarm = shift;
   my %params = @_;
  
   #Initialize the object with the passed in parameters
   my $self = \%params;
  
   #list of parameters to 
   my @jawsparams = qw(category correctiveaction	filterable	latching	offdelayseconds 
      ondelayseconds	pointofcontactusername priority	rationale);
   @jawsparams = sort(@jawsparams);  
   $self->{'paramlist'} = \@jawsparams;

   bless($self,$class);
  
   $self->{'name'} = %params->{'name'};   
     
   #If a JAWS alarm has not been passed, return.
   if (!$alarm) {
      return($self);
   }
 
   #Configure the JAWS class
   $self->{'alarm'} = $alarm;
   
   $self->config();   
   return($self);
}

## Configure the JAWS Class
sub config {
   my $self = shift;
   
   #Access the JAWS alarm associated with the class.
   my $alarm = $self->{'alarm'};
   my $classname = $alarm->{'class'};
   $self->{'name'} = uc($classname);
   
   my $category = $alarm->{'category'};
   
   
   my $params = $self->{'paramlist'};
   
   #Iterate through this is class parameters.
   #Copy the JAWS alarm values to the class
   foreach my $field (@$params) {     
      $self->{$field} = $alarm->{$field};
   }
   
   #Create the JAWS definition (string that is used to load class)
   my $jawsdef = createJAWSDef($self,$params);   
   $self->{'jawsdef'} = $jawsdef;
   
   #Just a flag to make sure each class has a category
   if (!$category) {
      print("NO CATEGORY FOR $classname\n");
   }   

   
}  


## Add the new JAWS CLASS  to the official list of classes
#  @param filename output file (optional)
sub addCLASSList {
   my $filename = $_[0];
   
   #The existing set of classes.
   my @classnamelist = keys(%classhash);
   my @classdefs;
   my @alllist; 
   my @finalnamelist;

   #Need the set of existing, whether or not we're updating the output file.
   my $classfile = $filename;
   if (!$filename) {
      $classfile = "./JAWS/CLASSES.jaws";
   }
   #Now, open up the class list file. 
   my @existingdefs;
   my @existingclasses;
   if (-e $classfile) {
      open(CLASSES,"$classfile") || die "unable to open \"$filename\" $!\n";
      @existingdefs = <CLASSES>;
      close(CLASSES); 
   } 
   
   #Create a JAWS CLASS for the definitions in the file.
   #Add to hash with temporary key "$name.$category"
   my %finalhash;
   foreach my $def (@existingdefs) {
      $def =~ m/(\b.*)=.*\"category\":\s+\"(\w+)\"/;
      my $name = $1;
      my $category = $2;
      my %jawsparams = (
         'name' => $name,
         'category' => $category,
         'jawsdef' => $def
      );
      my $jawsclass = new alhCLASS("",%jawsparams);
      my $key = "$name.$category";
      %finalhash->{$key} = $jawsclass;
   }
   
   #Add the new classes
   #If class has been redefined, it will replace the
   #existing JAWS CLASS with the new one.
   foreach my $key (keys(%classhash)) {
      my $jawsclass = %classhash->{$key};
      my $name = $jawsclass->{'name'};
      my $category = $jawsclass->{'category'};
      my $finalkey = "$name.$category";
      %finalhash->{$finalkey} = $jawsclass;
   }
   if (!$filename) {
      return;
   }
   
   #The final list of classes
   my @finallist = sort(keys(%finalhash));
   if ($filename) {
      
      open(CLASSES,"> $filename");
      foreach my $key (@finallist) {
         my $def = %finalhash->{$key}->{'jawsdef'};
         $def =~ s/\n//g;
         print(CLASSES "$def\n");
      }
      close(CLASSES);
      
      foreach my $classname (sort(@classnamelist)) {
         my $class = %classhash->{$classname};
         my $def = $class->{'jawsdef'};
         
         my $jaws = $class->{'alarm'};
         my $system = $jaws->{'system'};
         
      }
   } 
   
}
   
return 1;
