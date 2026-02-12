function detect_current_os -d "Détecte l'OS actuel"
    switch (uname -s)
        case "Linux"
            if test -f /proc/version
                and string match -q "*WSL*" (cat /proc/version)
                or string match -q "*Microsoft*" (cat /proc/version)
                echo "debian-wsl"
            else
                echo "debian"
            end
        case "Darwin"
            echo "macos"
    end
end
