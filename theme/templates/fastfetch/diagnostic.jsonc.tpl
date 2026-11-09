{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "file",
        "source": "~/.config/fastfetch/logo-arch.txt",
        "color": {
            "1": "{{ACCENT_BLUE}}",
            "2": "{{ACCENT_CYAN}}"
        },
        "padding": {
            "top": 0,
            "left": 1,
            "right": 3
        }
    },
    "display": {
        "separator": "  ",
        "color": {
            "keys": "{{ACCENT}}",
            "title": "{{ACCENT_BLUE}}"
        }
    },
    "modules": [
        "title",
        "separator",
        { "type": "os", "key": "os      " },
        { "type": "kernel", "key": "kernel  " },
        { "type": "packages", "key": "pkgs    " },
        { "type": "shell", "key": "shell   " },
        { "type": "terminal", "key": "term    " },
        { "type": "wm", "key": "wm      " },
        { "type": "cpu", "key": "cpu     " },
        { "type": "gpu", "key": "gpu     " },
        { "type": "memory", "key": "mem     " },
        { "type": "disk", "key": "disk    ", "folders": "/" },
        { "type": "uptime", "key": "up      " }
    ]
}
