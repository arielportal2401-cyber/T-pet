# A tiny, dependency-free terminal cat.
# Toggle it with `pet on` and `pet off`.

if status is-interactive
    if not set -q terminal_pet_enabled
        set -g terminal_pet_enabled 1
    end

    set -g __terminal_pet_shocked 0
    set -g __terminal_pet_critical 0

    function __terminal_pet_watch --on-event fish_postexec
        set -l command_status $status
        set -l commandline (string lower -- "$argv")

        # Ever run a risky build command with crossed fingers?
        # The pet does that too.
        if test $command_status -ne 0; and string match -rq \
                '(^|[;&|[:space:]])(cargo|cc|clang|clang\+\+|cmake|dotnet|g\+\+|gcc|go|gradle|gradlew|javac|make|mvn|ninja|nix|npm|pnpm|pytest|tsc|yarn)([[:space:]]|$)' \
                -- "$commandline"
            set -g __terminal_pet_critical 1
            set -g __terminal_pet_shocked 0
            return
        end

        set -g __terminal_pet_critical 0

        # Treat commands that commonly fill the screen as shocking.
        if string match -rq \
                '(^|[;&|[:space:]])(cat|dmesg|find|journalctl|less|man|rg|tree)([[:space:]]|$)|(^|[;&|[:space:]])ls[[:space:]].*-[^[:space:]]*r' \
                -- "$commandline"
            set -g __terminal_pet_shocked 1
        else
            set -g __terminal_pet_shocked 0
        end
    end

    function __terminal_pet_draw --on-event fish_prompt
        set -l last_status $status
        test "$terminal_pet_enabled" = 1; or return

        if test "$__terminal_pet_critical" = 1
            set_color brred
            printf '                 ⚠ CRITICAL ERROR\n'
            printf '               ╱\n'
            printf '             ╱  laser\n'
            printf ' /ᐠಥꞈ◉ᐟ\\ ╱\n'
            set_color normal
            echo '   the build hurt...'
            set -g __terminal_pet_critical 0
        else if test "$__terminal_pet_shocked" = 1
            set_color bryellow
            printf ' /ᐠOꞈOᐟ\\  '
            set_color normal
            echo 'whoa, that was a lot!'
            set -g __terminal_pet_shocked 0
        else if test $last_status -ne 0
            set_color brred
            printf ' /ᐠ×ꞈ×ᐟ\\  '
            set_color normal
            printf 'command exited %s\n' $last_status
        else
            set -l faces ' /ᐠ｡ꞈ｡ᐟ\\' ' /ᐠ˵- ⩊ -˵ᐟ\\' ' /ᐠ^ꞈ^ᐟ\\'
            set_color brblue
            printf '%s\n' $faces[(random 1 (count $faces))]
            set_color normal
        end
    end

    function pet --description 'Control the terminal cat'
        switch "$argv[1]"
            case on
                set -g terminal_pet_enabled 1
                echo 'Terminal cat is awake.'
            case off
                set -g terminal_pet_enabled 0
                echo 'Terminal cat is sleeping.'
            case status
                if test "$terminal_pet_enabled" = 1
                    echo 'Terminal cat is awake.'
                else
                    echo 'Terminal cat is sleeping.'
                end
            case '*'
                echo 'Usage: pet on | off | status'
        end
    end
end
