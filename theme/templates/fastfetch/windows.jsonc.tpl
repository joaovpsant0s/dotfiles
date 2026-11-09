{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "small",
        "padding": {
            "top": 0,
            "left": 1,
            "right": 3
        }
    },
    "display": {
        "separator": "   ",
        "color": {
            "keys": "{{ACCENT_PURPLE}}",
            "title": "{{ACCENT_PURPLE}}"
        }
    },
    "modules": [
        {
            "type": "custom",
            "format": "\u001b[1;38;2;187;154;247mhost\u001b[0m"
        },
        {
            "type": "custom",
            "format": "\u001b[38;2;59;66;97m────────────────\u001b[0m"
        },
        {
            "type": "os",
            "key": "os    ",
            "format": "Windows 11"
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
        }
    ]
}
