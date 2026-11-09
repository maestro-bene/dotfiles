function ssh-restart --description "Restart SSH agent via Keychain"
    if not command -q keychain
        echo "Keychain is unavailable." >&2
        return 127
    end

    echo "🔄 Restarting SSH agent..."
    command keychain --clear
    eval (command keychain --eval id_ed25519 id_rsa)
    echo "✅ SSH agent restarted"
end
