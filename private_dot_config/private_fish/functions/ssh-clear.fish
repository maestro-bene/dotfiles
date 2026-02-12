function ssh-clear --description "Clear all SSH keys"
    if command -v keychain >/dev/null
        keychain --clear
        echo "🧹 SSH agent cleared"
    else
        ssh-add -D
        echo "🧹 SSH keys cleared"
    end
end
