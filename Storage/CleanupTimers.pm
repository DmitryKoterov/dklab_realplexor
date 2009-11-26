##
## Storage::CleanupTimers: timers for each ID to cleanup queue
## which is not updated for a long time.
##
## Structure: { ID => TimerEvent }
##
package Storage::CleanupTimers;
use strict;
use base 'Exporter';
use Event::Lib;
our @EXPORT = qw($cleanup_timers);
our $cleanup_timers = new Storage::CleanupTimers();

sub new {
	my ($class) = @_;
	return bless {}, $class;
}

sub start_timer_for_id {
	my ($this, $id, $timeout, $callback) = @_;
	# Remove current timer if present.
	if ($this->{$id}) {
		$this->{$id}->remove();
		delete $this->{$id};
	}
	# Create new timer.
	$this->{$id} = timer_new(sub { 
		delete $this->{$id};
		$callback->();
	});
	# Start the timer.
	$this->{$id}->add($timeout);
}

sub get_num_items {
	my ($this) = @_;
	return scalar(keys %$this);
}

sub get_stats {
	my ($this) = @_;
	my @result = ();
	foreach my $id (sort keys %$this) {
		push @result, "$id => assigned";
	}
	return @result? join("\n", @result) . "\n" : "";
}

return 1;
