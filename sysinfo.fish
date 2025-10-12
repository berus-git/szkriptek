function sysinfo --description 'Kiírja a rendszer alapvető információit'
    # 1. Adatgyűjtés
    set -l dist_name (cat /etc/os-release 2>/dev/null | grep '^PRETTY_NAME=' | cut -d '"' -f 2)
    if test -z "$dist_name"
        set dist_name "Ismeretlen disztribúció"
    end
    set -l sys_name (uname -s)
    set -l kernel_ver (uname -r)
    set -l cpu_model (lscpu | grep 'Model name' | awk -F ': ' '{print $2}' | sed 's/^[ \t]*//')
    set -l mem_usage (free -h | awk '/Mem:/ {print $3 "/" $2 " (" $7 ")"}')
    set -l current_time (date '+%Y-%m-%d %H:%M:%S')
    set -l host_nev (hostname) 
    set -l uptime (uptime -p) 

    # 2. Kiírás
    echo "==================================="
    echo "       Rendszerösszefoglaló        "
    echo "==================================="
    echo "Disztribúció:          " $dist_name
    echo "Hosztnév:              " $host_nev
    echo "-----------------------------------"
    echo "Rendszer neve:         " $sys_name
    echo "Kernel verzió:         " $kernel_ver
    echo "-----------------------------------"
    echo "CPU típusa:            " $cpu_model
    echo "Memória foglaltság:    " $mem_usage
    echo "-----------------------------------"
    echo "Aktuális idő:          " $current_time
    echo "Üzemidő:               " $uptime
    echo "==================================="
end
