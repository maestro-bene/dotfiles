# Fish completion for generate_logs.
# Install this file at ~/.config/fish/completions/generate_logs.fish.

# Return true if the immediately preceding token is "-n" (which expects a number,
# not a filename).
function __generate_logs_prev_is_n
    set -l tokens (commandline -opc)
    test (count $tokens) -ge 1; and test "$tokens[-1]" = "-n"
end

# List available log files under ~/automation/logs,
# excluding files already present on the command line.
function __generate_logs_available_files
    set -l log_dir "$HOME/automation/logs"

    if not test -d "$log_dir"
        return
    end

    set -l all_files (find "$log_dir" -type f -name '*.log' \
        | sed "s|^$log_dir/||; s/\.log\$//")

    # Tokens already entered (excluding the command name)
    set -l tokens (commandline -opc)
    set -e tokens[1]

    set -l selected
    set -l skip_next 0
    for t in $tokens
        if test $skip_next -eq 1
            set skip_next 0
            continue
        end
        if test "$t" = "-n"
            set skip_next 1
            continue
        end
        if string match -q -- "-*" "$t"
            continue
        end
        # Remove any ":N" suffix before comparison
        set -a selected (string replace -r ':[0-9]*$' '' -- "$t")
    end

    for f in $all_files
        if not contains -- "$f" $selected
            echo "$f"
        end
    end
end

# Disable the shell's default file completion
complete -c generate_logs -f

# Options
complete -c generate_logs -s n -d "Number of repetitions" -r
complete -c generate_logs -s h -d "Show help"

# Complete log files, except immediately after -n
complete -c generate_logs \
    -n "not __generate_logs_prev_is_n" \
    -a "(__generate_logs_available_files)" \
    -d "Log file"


