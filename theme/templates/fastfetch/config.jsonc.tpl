{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "file",
        "source": "~/.config/fastfetch/logo-brasilia.txt",
        "color": {
            "1": "{{ACCENT}}",
            "2": "{{ACCENT_SECONDARY}}"
        },
        "padding": {
            "top": 1,
            "left": 2,
            "right": 3
        }
    },
    "display": {
        "separator": "  ▸ ",
        "color": {
            "keys": "{{ACCENT}}",
            "title": "{{ACCENT_SECONDARY}}"
        }
    },
    "modules": [
        {
            "type": "custom",
            "format": "╭─────────────────── BRASILIA-NIGHT // {{HOSTNAME}} ───────────────────╮"
        },
        {
            "type": "title",
            "key": "  USER   "
        },
        {
            "type": "custom",
            "key": "  ROLE   ",
            "format": "{{DISPLAY_NAME}} · UnB/FGA (Eng. Software & Monitor APC)"
        },
        {
            "type": "os",
            "key": "  OS     "
        },
        {
            "type": "kernel",
            "key": "  KERNEL "
        },
        {
            "type": "shell",
            "key": "  SHELL  "
        },
        {
            "type": "terminal",
            "key": "  TERM   "
        },
        {
            "type": "wm",
            "key": "  WM     "
        },
        {
            "type": "cpu",
            "key": "  CPU    "
        },
        {
            "type": "gpu",
            "key": "  GPU    "
        },
        {
            "type": "memory",
            "key": "  MEMORY "
        },
        {
            "type": "disk",
            "key": "  DISK   ",
            "folders": "/"
        },
        {
            "type": "custom",
            "key": "  RICE   ",
            "format": "variant={{VARIANT}} | accent={{ACCENT_NAME}} ({{ACCENT}})"
        },
        {
            "type": "custom",
            "format": "╰──────────────────────────────────────────────────────────────╯"
        },
        "break",
        {
            "type": "colors",
            "paddingLeft": 2,
            "symbol": "circle"
        }
    ]
}
