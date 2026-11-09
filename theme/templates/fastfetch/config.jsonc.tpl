{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "file",
        "source": "~/.config/fastfetch/logo-arch.txt",
        "color": {
            "1": "{{ACCENT_BLUE}}"
        },
        "padding": {
            "top": 0,
            "left": 1,
            "right": 3
        }
    },
    "display": {
        "separator": "   ",
        "color": {
            "keys": "{{ACCENT_BLUE}}",
            "title": "{{ACCENT_BLUE}}"
        }
    },
    "modules": [
        {
            "type": "custom",
            "format": "\u001b[1;38;2;122;162;247m{{SIGNATURE}}\u001b[0m"
        },
        {
            "type": "custom",
            "format": "\u001b[38;2;59;66;97m────────────────\u001b[0m"
        },
        {
            "type": "os",
            "key": "os    ",
            "format": "Arch Linux · WSL 2"
        },
        {
            "type": "shell",
            "key": "shell ",
            "format": "{process-name}"
        },
        {
            "type": "memory",
            "key": "mem   ",
            "format": "{used} / {total}"
        },
        {
            "type": "uptime",
            "key": "up    "
        },
        "break",
        {
            "type": "custom",
            "format": "\u001b[38;2;86;95;137mi use arch, btw\u001b[0m"
        }
    ]
}
