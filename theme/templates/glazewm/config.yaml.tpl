# =============================================================================
# NOCTURNE — GLAZEWM v3 CONFIGURATION
# Bordas e contraste vindos da paleta do Nocturne
# =============================================================================
general:
  startup_commands: ['shell-exec zebar']
  shutdown_commands: ['shell-exec taskkill /IM zebar.exe /F']
  config_reload_commands: []
  focus_follows_cursor: false
  toggle_workspace_on_refocus: true

  cursor_jump:
    enabled: true
    trigger: 'monitor_focus'

  hide_method: 'cloak'
  show_all_in_taskbar: false

gaps:
  scale_with_dpi: true
  inner_gap: '8px'
  outer_gap:
    top: '36px'
    right: '8px'
    bottom: '8px'
    left: '8px'

window_effects:
  focused_window:
    border:
      enabled: true
      color: '{{ACCENT}}'
  other_windows:
    border:
      enabled: true
      color: '{{BORDER}}'

window_behavior:
  initial_state: 'tiling'
  state_defaults:
    floating:
      centered: true
      shown_on_top: false
    fullscreen:
      maximized: false
      shown_on_top: false

workspaces:
  - name: '1'
    display_name: '1 · TERM'
  - name: '2'
    display_name: '2 · CODE'
  - name: '3'
    display_name: '3 · WEB'
  - name: '4'
    display_name: '4 · DATA'
  - name: '5'
    display_name: '5 · OPS'

window_rules:
  - commands: ['ignore']
    match:
      - window_process: { equals: 'zebar' }
      - window_title: { regex: '[Pp]icture.in.[Pp]icture' }
  - commands: ['set-floating']
    match:
      - window_class: { regex: 'Chrome_WidgetWin_1' }
        window_title: { regex: 'DevTools' }
      - window_process: { equals: 'Taskmgr' }

binding_modes:
  - name: 'resize'
    keybindings:
      - commands: ['resize --width -2%']
        bindings: ['h', 'left']
      - commands: ['resize --width +2%']
        bindings: ['l', 'right']
      - commands: ['resize --height +2%']
        bindings: ['k', 'up']
      - commands: ['resize --height -2%']
        bindings: ['j', 'down']
      - commands: ['wm-disable-binding-mode --name resize']
        bindings: ['escape', 'enter']

keybindings:
  - commands: ['focus --direction left']
    bindings: ['alt+h', 'alt+left']
  - commands: ['focus --direction right']
    bindings: ['alt+l', 'alt+right']
  - commands: ['focus --direction up']
    bindings: ['alt+k', 'alt+up']
  - commands: ['focus --direction down']
    bindings: ['alt+j', 'alt+down']

  - commands: ['move --direction left']
    bindings: ['alt+shift+h', 'alt+shift+left']
  - commands: ['move --direction right']
    bindings: ['alt+shift+l', 'alt+shift+right']
  - commands: ['move --direction up']
    bindings: ['alt+shift+k', 'alt+shift+up']
  - commands: ['move --direction down']
    bindings: ['alt+shift+down', 'alt+shift+j']

  - commands: ['wm-enable-binding-mode --name resize']
    bindings: ['alt+r']
  - commands: ['toggle-floating --centered']
    bindings: ['alt+shift+space']
  - commands: ['toggle-fullscreen']
    bindings: ['alt+f']
  - commands: ['close']
    bindings: ['alt+shift+q']
  - commands: ['wm-reload-config']
    bindings: ['alt+shift+r']
  - commands: ['shell-exec wt.exe']
    bindings: ['alt+enter']

  - commands: ['focus --workspace 1']
    bindings: ['alt+1']
  - commands: ['focus --workspace 2']
    bindings: ['alt+2']
  - commands: ['focus --workspace 3']
    bindings: ['alt+3']
  - commands: ['focus --workspace 4']
    bindings: ['alt+4']
  - commands: ['focus --workspace 5']
    bindings: ['alt+5']

  - commands: ['move --workspace 1', 'focus --workspace 1']
    bindings: ['alt+shift+1']
  - commands: ['move --workspace 2', 'focus --workspace 2']
    bindings: ['alt+shift+2']
  - commands: ['move --workspace 3', 'focus --workspace 3']
    bindings: ['alt+shift+3']
  - commands: ['move --workspace 4', 'focus --workspace 4']
    bindings: ['alt+shift+4']
  - commands: ['move --workspace 5', 'focus --workspace 5']
    bindings: ['alt+shift+5']
