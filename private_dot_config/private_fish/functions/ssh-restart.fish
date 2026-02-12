function ssh-restart --description "Restart SSH agent via Keychain"
    if command -v keychain >/dev/null
        echo "🔄 Restarting SSH agent..."
        keychain --clear
        eval (keychain --eval id_ed25519 id_rsa)
        echo "✅ SSH agent restarted"
    else
        echo "❌ Keychain not available"
    end
end
