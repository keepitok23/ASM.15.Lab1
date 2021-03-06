package ST21;
use 5.14.0;
use strict;

my @records;
my @procedures = (\&add, \&edit, \&delete, \&show_all, \&save, \&open);

sub st21
{

my $greetings = "Choose procedure:\n 1. Add record;\n 2. Edit record;\n 3. Delete record;\n 4. Show all records;\n 5. Save;\n 6. Open file;\n 7. Exit. \n";



while(1) {

say $greetings;
chomp(my $answer = <STDIN>);


given($answer) {
	when("1"){@procedures[0]->();}
	when("2"){@procedures[1]->();}
	when("3"){@procedures[2]->();}
	when("4"){@procedures[3]->();}
	when("5"){@procedures[4]->();}
	when("6"){@procedures[5]->();}
	when("7"){return 1;}
	default {say "Error. Procedure have not found. Please, try again\n";}
	}
}
}

sub add {
	say " Add record\n";
	
	say "Title:";
	my $title = <STDIN>;
	say "Year:";
	my $year = <STDIN>;
	say "Country:";
	my $country = <STDIN>;
	say "Rate:";
	my $rate = <STDIN>; 
	
	my $new_record = {Title => $title, Year => $year, Country => $country, Rate => $rate};
	 
	push (@records, $new_record);
	
	say "\n Record added!\n";
}
	
sub edit {
	
	show_all();
	print "Enter the number of the record, which you want to edit: ";
	my $number = <STDIN>;
	
	if (defined(@records[$number-1])) {
	
	say "Title:";
	@records[$number-1]->{Title} = <STDIN>;	
	say "Year:";
	@records[$number-1]->{Year} = <STDIN>;
	say "Country:";
	@records[$number-1]->{Country} = <STDIN>;
	say "Rate:";
	@records[$number-1]->{Rate} = <STDIN>;
	
	say "The record has been changed!";
	}
	else { say "The record doesn't exist!";
	
	}
}
	
sub delete {
	
	show_all();
	print "Enter the number of the record, which you want to delete: ";
	my $number = <STDIN>;
	
	if (defined(@records[$number-1])) {
	splice(@records, $number-1, 1);
	say "The record has been deleted!";
	}
	
	else { say "The record doesn't exist!";
	;
	}
}
	
sub show_all {
	
	say " The list of all records:\n";
	my $count = 1;
	while (defined(@records[$count-1])) {
	say $count . ". " . "Title: " . @records[$count-1]->{Title} . "   Year: " . @records[$count-1]->{Year} . "   Country: " . @records[$count-1]->{Country} . "   Rate: " . @records[$count-1]->{Rate};
	$count = $count + 1;
	}	
	
	
	}
	
sub save {
	
	print "Enter name of the file: ";

	chomp (my $file = <STDIN>);

	dbmopen(my %hash, $file, 0666);

	my $id = 0;
	
	while (defined(@records[$id])) {
	$hash{$id} = join('#', @records[$id]->{Title}, @records[$id]->{Year}, @records[$id]->{Country}, @records[$id]->{Rate});
	$id = $id +1;
	}
	dbmclose (%hash);
	say "File sucsessfully saved!";
	
	}
	
sub open {
	
	print "Enter name of file to open: ";
	
	chomp(my $file = <STDIN>);
	
	dbmopen (my %hash, $file ,0666) or die "Can't load file!\n";
		@records = ();
		while (my ($key, $value) = each(%hash))
		{
			my ($title, $year, $country, $rate) = split(/#/, $value);
			my %record = (
				'Title' => $title,
				'Year' => $year,
				'Country' => $country,
				'Rate' => $rate
			);
			push(@records, \%record);
		}
		dbmclose %hash;
		
	say "File sucsessfully opened!";
	
		
}
	
