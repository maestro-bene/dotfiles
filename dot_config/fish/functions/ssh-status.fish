function ssh-status --description "Show SSH agent status"
    echo "🔍 SSH Agent Status"
    echo "=================="

    if command -q keychain
        echo "📊 Keychain info:"
        command keychain --list 2>/dev/null; or echo "No keychain info available"
        echo ""
    end

    if command -q ssh-add
        echo "🔑 Loaded keys:"
        command ssh-add -l
    else
        echo "ssh-add is unavailable." >&2
        return 127
    end
end
