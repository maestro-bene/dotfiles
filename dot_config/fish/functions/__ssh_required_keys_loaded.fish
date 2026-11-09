function __ssh_required_keys_loaded
    # Interroge uniquement l'agent hérité.
    set -l agent_keys (command ssh-add -l -E sha256 2>/dev/null)
    or return 1

    # Compare les empreintes des deux clés publiques locales.
    for pub in "$HOME/.ssh/id_ed25519.pub" "$HOME/.ssh/id_rsa.pub"
        test -r "$pub"
        or return 1

        set -l description (command ssh-keygen -l -E sha256 -f "$pub" 2>/dev/null)
        or return 1

        set -l fields (string split -n ' ' -- $description)
        set -q fields[2]
        or return 1

        string match -q -- "* $fields[2] *" $agent_keys
        or return 1
    end

    return 0
end
