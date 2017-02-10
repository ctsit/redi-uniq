# Helper script for setting up your apps local instance
# Contributors:
# Roy Keyes <keyes@ufl.edu>

help:
	@echo "Available tasks :"
	@echo "\tuniq - Create the unique file based from a raw file"
	@echo "\tcprep - Copy the reports files from all the runs"
	@echo "\temr - Get the EMR data"
	@echo "\tlastlog - Get the last log for a particular subject (ID=000-0000)"
	@echo "\twatch - Watch the state of the current run for a specific site"

uniq:
	@bash get_unique.sh

cprep:
	@bash collect_reports.sh

emr:
	@bash get_emr.sh

lastlog:
	@bash get_last_log.sh "" $$ID

watch:
	@bash watch_run.sh
