function log_function
    if test "$LOG" = "Log"
        # Run command normally
        if functions -q $argv[1]
            eval $argv
        else 
            command $argv
        end
    else
        # Run command with output suppressed
        if functions -q $argv[1]
            eval $argv > /dev/null 2>&1
        else 
            command $argv > /dev/null 2>&1
        end
    end
end
