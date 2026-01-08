[ default ]
@_:
  just ui 2>/dev/null || just --list

@bootstrap:
  just flake bootstrap 2>/dev/null || echo "No user bootstrap defined."

# import user justfile if it exists
user_justfile := "{{
  if env('XDG_CACHE_HOME', '') =~ '^/' { env('XDG_CACHE_HOME') }
  else { home_directory() / '/.cache' }
}}/justfiles/justfile"

import? "{{user_justfile}}"
