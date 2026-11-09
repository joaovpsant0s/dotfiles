{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "none"
    },
    "display": {
        "separator": "  ",
        "color": {
            "keys": "{{ACCENT_BLUE}}"
        }
    },
    "modules": [
        {
            "type": "custom",
            "format": "\u001b[1;38;2;122;162;247m▲ {{SIGNATURE}}\u001b[0m \u001b[38;2;59;66;97m──────────\u001b[0m"
        },
        {
            "type": "os",
            "key": "os   ",
            "format": "Arch · WSL 2"
        },
        {
            "type": "shell",
            "key": "sh   ",
            "format": "{process-name}"
        },
        {
            "type": "memory",
            "key": "mem  ",
            "format": "{used}/{total}"
        },
        {
            "type": "uptime",
            "key": "up   "
        },
        {
            "type": "custom",
            "format": "\u001b[38;2;86;95;137mi use arch, btw\u001b[0m"
        }
    ]
}
