function log --description 'Print debug messages to stderr'
    if test "$LOG" != Log
        return 0
    end

    if not set -q argv[1]
        return 0
    end

    printf '%s\n' "$argv" >&2
end

