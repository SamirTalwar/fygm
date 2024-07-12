source ($nu.config-path | path dirname | path join 'default_config.nu')

use std

# disable the banner
$env.config.show_banner = false

# Use vi bindings at the prompt
$env.config.edit_mode = vi
$env.config.cursor_shape.vi_insert = line
$env.config.cursor_shape.vi_normal = block

# Attach direnv to the prompt
$env.config.hooks.pre_prompt = $env.config.hooks.pre_prompt ++ [{
  let direnv = (direnv export json | from json | default {})
  if ($direnv | is-empty) {
      return
  }
  $direnv
  | items {|key, value|
     {
        key: $key
        value: (if $key in $env.ENV_CONVERSIONS {
          do ($env.ENV_CONVERSIONS | get $key | get from_string) $value
        } else {
            $value
        })
      }
  } | transpose -ird | load-env
}]

# Set the PATH:
$env.PATH = (do {
  let mac_path = (
    if $nu.os-info.name == "macos" {
      [
        ~/bin/mac
        ~/.homebrew/bin
      ]
    } else {
      []
    }
  )
  let unix_path = [
    ~/bin/unix
    ~/.local/bin
    ~/.cargo/bin
    ~/go/bin
    ~/.nix-profile/bin
    /opt/jetbrains/bin
    /usr/local/bin
    /nix/var/nix/profiles/default/bin
    /run/wrappers/bin
    /run/current-system/sw/bin
  ]
  $mac_path ++ $unix_path ++ $env.PATH
})

# Prepend the user's channels to the NIX_PATH:
$env.NIX_PATH = [$"($nu.home-path)/.nix-defexpr/channels"] ++ ($env | get -i NIX_PATH | if $in != null { $in } else { [] })

# Initialize and source shell improvements (installed with `up`):
source ~/.cache/nushell/starship.nu
source ~/.cache/nushell/zoxide.nu

# Wrap zoxide functions to also set the window title
def --env __zoxide_z_title [...rest] {
  __zoxide_z ...$rest
  title
}

def --env __zoxide_zi_title [...rest:string] {
  __zoxide_zi ...$rest
  title
}

alias z = __zoxide_z_title
alias zi = __zoxide_zi_title
