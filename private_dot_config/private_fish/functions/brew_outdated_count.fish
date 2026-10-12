# ~/.config/fish/functions/brew_outdated_count.fish
function brew_outdated_count --description 'Return number of outdated Homebrew formulae/casks (cached)'
    # TTL du cache en secondes (ex: 3600 = 1h)
    set -l ttl (string match -r '^\d+$' "$argv[1]"; and echo $argv[1]; or echo 3600)

    set -l cache_dir ~/.cache/fish
    set -l cache_file $cache_dir/brew_outdated_count.txt
    set -l stamp_file $cache_dir/brew_outdated_stamp.txt
    mkdir -p $cache_dir

    # Si pas de brew, toujours 0
    if not type -q brew
        echo 0
        return
    end

    # Lire l’horodatage du dernier calcul
    set -l now (date +%s)
    set -l last 0
    if test -f $stamp_file
        set last (cat $stamp_file)
    end

    # Si cache valide, renvoyer directement
    if test -f $cache_file
        if test (math $now - $last) -lt $ttl
            cat $cache_file
            return
        end
    end

    # Recalcule et met à jour le cache
    # --quiet pour limiter la sortie; --greedy pour inclure les casks (retire-le si tu veux seulement formulae)
    set -l count (brew outdated --greedy --quiet | count)
    echo $count > $cache_file
    echo $now > $stamp_file
    echo $count
end
