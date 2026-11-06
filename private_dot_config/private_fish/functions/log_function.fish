function log_function --description 'Run a command, hiding stdout unless debugging'
    if not set -q argv[1]
        printf '%s\n' 'log_function: missing command' >&2
        return 2
    end

    if test -z "$argv[1]"
        printf '%s\n' 'log_function: empty command' >&2
        return 2
    end

    if test "$LOG" = Log
        $argv
        return $status
    else
        # Keep stderr visible even when stdout is suppressed.
        $argv >/dev/null
        return $status
    end
end

