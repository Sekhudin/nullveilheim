---
name: Nix Noctalia
description: Develop Noctalia external plugins, local plugins, and theme templates in this repository
---

# Nix Noctalia Development

Use this skill when integrating Noctalia external plugins, developing local
plugins, or adding theme templates.

This skill does not cover general Noctalia core configuration, repository core
IPC wrapper modules, bars, docks, services, or Hyprland integration.

For detailed plugin, Luau, and template patterns, read:

```text
.agents/skills/nix-noctalia/reference.md
```

## Safety Rules

- Read and follow `AGENTS.md`.
- Preserve the existing Noctalia module and directory structure.
- Do not read, decrypt, modify, or remove files under `secrets/`.
- Do not expose secrets, credentials, tokens, or private machine data.
- Review external plugin sources and permissions before integrating them.
- Do not add runtime network access to local plugins without a clear
  requirement.
- Existing official and community plugin sources may use the configured Git
  sources, but review their source and permissions before integrating them.
- Do not add persistent processes or filesystem watchers without a clear
  requirement.
- Do not apply system-wide changes.
- Do not commit or push unless explicitly requested.
- Preserve unrelated user changes.

## Repository Architecture

Noctalia configuration is automatically imported recursively from:

```text
modules/home/desktop/
```

Noctalia-specific files are organized as:

```text
modules/home/desktop/noctalia/
├── plugins/
├── local-plugins/
└── templates/
```

The recursive module loader is defined in:

```text
modules/home/desktop/default.nix
```

Do not add redundant manual imports for ordinary `.nix` modules.

## Workflow

1. Read `AGENTS.md` and this skill.
2. Inspect Git status and preserve unrelated changes.
3. Verify the actual paths of existing Noctalia modules, plugins, and templates.
4. Identify whether the change is a Nix integration, external plugin,
   local plugin, or theme template.
5. Inspect an existing equivalent implementation before creating a new file.
6. Follow the patterns in
   `.agents/skills/nix-noctalia/reference.md`.
7. Add only the required packages, settings, metadata, and entrypoints.
8. Review generated paths, plugin IDs, and component IDs.
9. Validate the affected Nix and plugin files.
10. Review the complete diff.

## Module Placement

Use these directories:

```text
plugins/noctalia/   official Noctalia plugin integrations
plugins/comunity/   community plugin integrations
plugins/local/      local plugin integrations
local-plugins/      local Noctalia plugin source
templates/          theme templates and template integrations
```

Preserve the existing `comunity` directory spelling.

## Validation

At minimum, run:

```sh
nixfmt --check path/to/changed-file.nix
git diff --check
```

For affected Nix outputs, evaluate the relevant Home Manager or NixOS
configuration and run:

```sh
nix flake check --all-systems
```

For local plugins, validate `plugin.toml` metadata, referenced Luau
entrypoints, translation keys, component IDs, and configured Noctalia settings.

Do not report validation as passed when it was skipped, blocked, or failed.
