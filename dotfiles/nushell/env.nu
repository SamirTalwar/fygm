source ($nu.config-path | path dirname | path join 'default_env.nu')

# Convert `NIX_PATH` into a list
$env.ENV_CONVERSIONS."NIX_PATH" = {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str join (char esep) }
}
