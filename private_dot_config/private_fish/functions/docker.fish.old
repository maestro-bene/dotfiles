function docker
    if test (count $argv) -gt 0
        if test "$argv[1]" = "build"
            set argv "buildx" $argv
        end
    end
    command docker $argv
end
