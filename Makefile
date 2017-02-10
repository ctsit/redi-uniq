# Helper script for setting up your apps local instance
# Contributors:
# Roy Keyes <keyes@ufl.edu>

help:
	@echo ""
	@echo "--Pre-RED-I Tasks:"
	@echo ""
	@echo "\temr - Get the EMR data (based on a RED-I settings.ini file)"
	@echo "\tfilter - Filter 'raw.txt' based on a configured rule list"
	@echo "\tcount - Count lines in 'raw.txt' and compare to per participant files"
	@echo "\tuniq - Create the unique file based from a raw file"
	@echo ""
	@echo "--During-RED-I Tasks:"
	@echo ""
	@echo "\tlastlog - Get the last log for a particular subject (ID=000-0000)"
	@echo "\twatch - Watch the state of the current run for a specific site"
	@echo ""
	@echo "--Post-RED-I Tasks:"
	@echo ""
	@echo "\tcprep - Copy reports files from complete runs"
	@echo ""

# Pre RED-I Tasks
emr:
	@bash get_emr.sh

filter:
	@bash filter_raw.sh

count:
	@bash count_lines.sh

uniq:
	@bash get_unique.sh

# During RED-I Tasks

lastlog:
	@bash get_last_log.sh "" $$ID

watch:
	@bash watch_run.sh

# Post RED-I Tasks
cprep:
	@bash collect_reports.sh
