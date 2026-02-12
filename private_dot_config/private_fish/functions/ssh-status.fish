function ssh-status --description "Show SSH agent status"
    echo "🔍 SSH Agent Status"
    echo "=================="
    
    if command -v keychain >/dev/null
        echo "📊 Keychain info:"
        keychain --list 2>/dev/null || echo "No keychain info available"
        echo ""
    end
    
    echo "🔑 Loaded keys:"
    ssh-add -l
end
