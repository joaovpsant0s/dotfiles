{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "file",
        "source": "~/.config/fastfetch/logo-windows.txt",
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
            "format": "Windows",
            "outputColor": "{{ACCENT_CYAN}}"
        },
        "break",
        {
            "type": "os",
            "key": "os    ",
            "format": "{pretty-name}"
        },
        {
            "type": "shell",
            "key": "shell ",
            "format": "{process-name}"
        },
        {
            "type": "kernel",
            "key": "build ",
            "format": "{release}"
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
            "type": "uptime",
            "key": "up    "
        }
    ]
}
