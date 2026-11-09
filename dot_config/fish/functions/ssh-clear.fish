function ssh-clear --description "Clear all SSH keys"
    if command -q keychain
        command keychain --clear
        echo "🧹 SSH agent cleared"
    else if command -q ssh-add
        command ssh-add -D
        echo "🧹 SSH keys cleared"
    else
        echo "Neither keychain nor ssh-add is available." >&2
        return 127
    end
end
