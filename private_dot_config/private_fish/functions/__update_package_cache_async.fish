function __update_package_cache_async \
        --description 'Refresh a package counter in a separate process' \
        --argument-names provider ttl

    set -l stem

    switch "$provider"
        case apt
            set stem apt_upgradable
        case brew
            set stem brew_outdated
        case '*'
            return 2
    end

    set -l executable (command -s "$provider")
    test -n "$executable"; or return 0
    command -q flock; or return 1

    set -l cache_dir "$HOME/.cache/fish"
    command mkdir -p -- "$cache_dir"; or return 1

    # flock holds the lock for the entire worker execution.
    command flock -n "$cache_dir/$stem.lock" \
        (status fish-path) --no-config -c '
        set -l stem "$argv[1]"
        set -l cache_dir "$argv[2]"
        set -l ttl "$argv[3]"
        set -l executable "$argv[4]"

        set -l stamp "$cache_dir/$stem"_stamp.txt
        set -l target "$cache_dir/$stem"_count.txt
        set -l raw "$cache_dir/$stem"_output.tmp
        set -l tmp "$cache_dir/$stem"_count.tmp

        set -l now (command date +%s)
        set -l last 0

        if test -f "$stamp"
            read -l last < "$stamp"; or set last 0
            string match -qr "^[0-9]+\$" -- "$last"; or set last 0
        end

        set -l age (math "$now - $last")

        if test -f "$target"; and test "$age" -ge 0; and test "$age" -lt "$ttl"
            exit 0
        end

        set -gx LC_ALL C

        switch "$stem"
            case apt_upgradable
                command "$executable" list --upgradable > "$raw"
                or exit 1

                command grep -F -c "[upgradable from:" "$raw" > "$tmp"
                set -l grep_status $status

                # grep returns 1 when there are no matching packages.
                if test "$grep_status" -gt 1
                    exit 1
                end

            case brew_outdated
                set -gx HOMEBREW_NO_AUTO_UPDATE 1

                command "$executable" outdated --greedy --quiet > "$raw"
                or exit 1

                # A zero count is valid, regardless of count exit status.
                count < "$raw" > "$tmp"
        end

        command mv -f -- "$tmp" "$target"; or exit 1

        command date +%s > "$stamp.tmp"; or exit 1
        command mv -f -- "$stamp.tmp" "$stamp"; or exit 1

        command rm -f -- "$raw"
    ' "$stem" "$cache_dir" "$ttl" "$executable" \
        </dev/null >>"$cache_dir/$stem"_async.log 2>&1 &

    set -l worker_pid $last_pid
    disown "$worker_pid"
end
