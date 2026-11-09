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
            "top": 1,
            "left": 1,
            "right": 3
        }
    },
    "display": {
        "separator": "  ",
        "color": {
            "keys": "{{ACCENT_BLUE}}",
            "title": "{{ACCENT_BLUE}}",
            "output": "{{FOREGROUND}}"
        }
    },
    "modules": [
        {
            "type": "custom",
            "format": "nocturne  /  {{SIGNATURE}}",
            "outputColor": "{{ACCENT_BLUE}}"
        },
        "break",
        {
            "type": "os",
            "key": "os    ",
            "format": "{name}{$NOCTURNE_WSL_SUFFIX}"
        },
        {
            "type": "shell",
            "key": "shell ",
            "format": "{process-name}"
        },
        {
            "type": "packages",
            "key": "pkgs  ",
            "format": "{pacman} pacman"
        },
        {
            "type": "cpu",
            "key": "cpu   ",
            "format": "{name} · {cores-logical}t"
        },
        {
            "type": "gpu",
            "key": "gpu   ",
            "format": "{name}",
            "hideType": "integrated"
        },
        {
            "type": "memory",
            "key": "mem   ",
            "format": "{used} / {total}  {percentage}"
        },
        {
            "type": "disk",
            "key": "disk  ",
            "format": "{size-used} / {size-total} · {filesystem}",
            "folders": "/"
        },
        {
            "type": "uptime",
            "key": "up    "
        },
        "break",
        {
            "type": "custom",
            "format": "{{TAGLINE}}",
            "outputColor": "{{FOREGROUND_MUTED}}"
        }
    ]
}
