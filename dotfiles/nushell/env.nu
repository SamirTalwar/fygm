source ($nu.config-path | path dirname | path join 'default_env.nu')

# Convert `NIX_PATH` into a list.
$env.ENV_CONVERSIONS."NIX_PATH" = {
    from_string: { split row (char esep) }
    to_string: { str join (char esep) }
}

# Add SSH keys to the keychain.
# This is probably the wrong place for this, but… whatever.
[~/.ssh/id_ed25519 ~/.ssh/id_rsa] | each { |private_key|
  if ($private_key | path exists) {
    ssh-add ($private_key | path expand)
  }
} | null
