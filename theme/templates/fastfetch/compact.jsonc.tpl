{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "none"
    },
    "display": {
        "separator": "  ",
        "color": {
            "keys": "{{ACCENT_BLUE}}",
            "output": "{{FOREGROUND}}"
        }
    },
    "modules": [
        {
            "type": "custom",
            "format": "Arch Linux",
            "outputColor": "{{ACCENT_BLUE}}"
        },
        {
            "type": "os",
            "key": "os   ",
            "format": "{name}{$NOCTURNE_WSL_SUFFIX}"
        },
        {
            "type": "shell",
            "key": "shell",
            "format": "{process-name}"
        },
        {
            "type": "memory",
            "key": "mem  ",
            "format": "{used} / {total}"
        },
        {
            "type": "uptime",
            "key": "up   "
        }
    ]
}
