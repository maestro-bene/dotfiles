# Complétion fish pour generate_logs
# Placer ce fichier dans : ~/.config/fish/completions/generate_logs.fish

# Vrai si le token précédent immédiat est "-n" (on attend alors un nombre,
# pas un nom de fichier).
function __generate_logs_prev_is_n
    set -l tokens (commandline -opc)
    test (count $tokens) -ge 1; and test "$tokens[-1]" = "-n"
end

# Liste les fichiers de log disponibles sous ~/automation/logs,
# en excluant ceux déjà présents sur la ligne de commande.
function __generate_logs_available_files
    set -l log_dir "$HOME/automation/logs"

    if not test -d "$log_dir"
        return
    end

    set -l all_files (find "$log_dir" -type f -name '*.log' \
        | sed "s|^$log_dir/||; s/\.log\$//")

    # Tokens déjà tapés (hors nom de la commande)
    set -l tokens (commandline -opc)
    set -e tokens[1]

    set -l selected
    set -l skip_next 0
    for t in $tokens
        if test $skip_next -eq 1
            set skip_next 0
            continue
        end
        if test "$t" = "-n"
            set skip_next 1
            continue
        end
        if string match -q -- "-*" "$t"
            continue
        end
        # Retirer un éventuel suffixe ":N" avant comparaison
        set -a selected (string replace -r ':[0-9]*$' '' -- "$t")
    end

    for f in $all_files
        if not contains -- "$f" $selected
            echo "$f"
        end
    end
end

# Désactiver la complétion de fichiers par défaut du shell
complete -c generate_logs -f

# Options
complete -c generate_logs -s n -d "Nombre de répétitions par défaut" -r
complete -c generate_logs -s h -d "Affiche l'aide"

# Complétion des fichiers de log, sauf juste après -n
complete -c generate_logs \
    -n "not __generate_logs_prev_is_n" \
    -a "(__generate_logs_available_files)" \
    -d "Fichier de log"


