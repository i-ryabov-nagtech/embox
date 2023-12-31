#
# Checks for necessary Make flags and defines a no-op default target.
#
#   Date: Feb 21, 2012
# Author: Eldar Abusalimov
#

ifeq ($(filter --no-print-directory,$(MAKEFLAGS)),)
$(error '--no-print-directory' flag must be specified)
endif

GEN_BANNER := Generated by GNU Make $(MAKE_VERSION). Do not edit.

include mk/core/string.mk

# Wraps the given rule with a script which compares the command output with
# the original file (if it exists) and replaces the latter only in case when
# contents differ.
#   1. Output file.
#   2. The complete command which should output its result to the temporary
#      file specified in the '$OUTFILE' environment variable.
cmd_notouch = \
	set_on_error_trap() { trap "$$1" INT QUIT TERM HUP EXIT; };            \
	COMMAND=$(call sh_quote,set_on_error_trap "$(RM) $$OUTFILE"; { $2; }); \
	OUTFILE=$(call trim,$1);                                               \
	if [ ! -f $$OUTFILE ];                                                 \
	then                                                                   \
		__OUTDIR=`dirname $$OUTFILE`;                                      \
		{ [ -d $$__OUTDIR ] || $(MKDIR) $$__OUTDIR; }                      \
			&& eval "$$COMMAND" && set_on_error_trap -;                    \
	else                                                                   \
		__OUTFILE=$$OUTFILE; OUTFILE=$${TMPDIR:-/tmp}/Mybuild.$$$$;        \
		eval "$$COMMAND"                                                   \
			&& { cmp -s $$OUTFILE $$__OUTFILE >/dev/null 2>&1              \
					|| { $(MV) $$OUTFILE $$__OUTFILE                       \
							&& set_on_error_trap -; }; };                  \
	fi

#   1. Output file.
#   2. The command which outputs its result to stdout.
cmd_notouch_stdout = \
	$(call cmd_notouch,$1,{ $2; } > $$OUTFILE)

sh_quote = \
	'$(subst ','\'',$1)'

.DEFAULT_GOAL := all

.PHONY : all
all :
	@:
