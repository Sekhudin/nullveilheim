---
name: Nix Validation
description: Validate Nix configuration changes with formatting, diff checks, evaluation, and builds
---

# Nix Validation

Use this skill after modifying Nix files, flake inputs, overlays, package
definitions, or system configurations.

The goal is to validate affected changes without applying system-wide
configuration changes.

## Safety Rules

- Read and follow the repository's `AGENTS.md`.
- Do not read, decrypt, modify, or remove files under `secrets/`.
- Do not modify `.sops.yaml`.
- Do not expose secrets, credentials, tokens, private keys, or sensitive data.
- Do not apply automatic fixes unless explicitly requested.
- Do not commit or push changes.
- Do not run `nixos-rebuild switch`.
- Do not run `darwin-rebuild switch`.
- Do not apply system-wide changes.

When inspecting Git status or diffs, avoid files under `secrets/` and never
include sensitive values in logs or reports.

## Validation Levels

Choose the smallest level that provides sufficient confidence.

### Minimal validation

Use for comments or small isolated Nix edits:

```sh
nixfmt --check path/to/changed-file.nix
git diff --check
```

For documentation-only changes, skip Nix formatting and run only:

```sh
git diff --check
```

Run `nixfmt --check` only when Nix files were changed.

### Standard validation

Use for normal Nix modules, overlays, package definitions, and flake changes:

```sh
nixfmt --check path/to/changed-file.nix
git diff --check
nix flake check --all-systems
```

### Deep validation

Use when changing flake inputs, `flake.lock`, package overlays, Home Manager
modules, NixOS or nix-darwin modules, host configurations, or desktop
integration.

Run standard validation, then evaluate or build the affected package,
configuration, or flake output.

## Workflow

1. Read `AGENTS.md`.
2. Inspect the relevant Git status and diff for the current changes.
3. Identify changed Nix files and affected outputs.
4. Determine the appropriate validation level.
5. Run the relevant formatter checks.
6. Run `git diff --check`.
7. Run `nix flake check --all-systems` when the flake or Nix outputs are
   affected.
8. Evaluate or build the affected output when practical.
9. Review the complete diff for unintended changes when no sensitive paths are
   involved. Otherwise, inspect only known changed files.
10. Report commands, results, warnings, and follow-up actions.

Preserve unrelated user changes. Do not revert or discard them.

## Formatting Validation

Check each changed Nix file:

```sh
nixfmt --check path/to/changed-file.nix
```

For multiple changed files:

```sh
nixfmt --check path/to/file-one.nix path/to/file-two.nix
```

Do not claim formatting passed if the command was skipped or failed.

## Diff Validation

Always check for whitespace errors:

```sh
git diff --check
```

Review relevant unstaged and staged changes when applicable:

```sh
git status --short
git diff
git diff --cached
```

When secrets or sensitive paths may be present, inspect only known changed
files instead of running an unrestricted diff. Do not inspect or report secret
contents.

## Flake Validation

For flake, input, lockfile, overlay, package, or module changes, run:

```sh
nix flake check --all-systems
```

The `--all-systems` flag checks outputs for all systems declared by the flake,
including:

```text
x86_64-linux
aarch64-linux
aarch64-darwin
```

Use plain `nix flake check` only when a faster current-system check is
intentional and sufficient.

`nix flake check` does not necessarily evaluate every host configuration or
build every package. Validate affected outputs separately when necessary.

Record and report warnings such as:

- Dirty Git tree warnings.
- Unsupported systems being skipped.
- Unknown or intentionally omitted flake outputs.
- Existing evaluation warnings.

## Change-Specific Validation

### Flake input or lockfile changes

Run:

```sh
nix flake check --all-systems
```

Inspect the complete `flake.lock` diff and verify that:

- The requested input exists.
- Unused inputs were removed only when appropriate.
- Follows relationships are correct.
- Transitive dependency changes are expected.

### Overlay or package changes

Evaluate or build the affected package when practical:

```sh
nix eval .#legacyPackages.x86_64-linux.package-name
nix build .#packages.x86_64-linux.package-name
```

These are examples only. First inspect the flake outputs and replace
`package-name` with an output that actually exists.

Check relevant systems when the package is exposed globally.

### Home Manager changes

Identify the affected Home Manager output from the flake, then evaluate it.
Build it when practical.

Do not run a system switch.

### NixOS or nix-darwin changes

Evaluate the affected system configuration when practical.

Do not run:

```sh
nixos-rebuild switch
darwin-rebuild switch
```

### Hyprland or desktop changes

Evaluate the affected Home Manager or desktop configuration. Check that
platform-specific modules and generated configuration remain valid.

## Evaluation and Build Rules

Before evaluating or building a flake output, inspect the available outputs:

```sh
nix flake show
```

Use only output paths that actually exist. Do not guess output names.

Prefer evaluation before building when diagnosing changes:

```sh
nix eval .#<output>
```

Build the affected output when practical:

```sh
nix build .#<output>
```

Use the exact output name exposed by the flake. Do not invent an output path
without checking the flake outputs first.

Run both when the change affects package definitions or derivations.

If a build is impractical because of time, network, platform, or resource
constraints, report that clearly instead of claiming the build passed.

If validation cannot run because of unavailable network access, unsupported
architecture, missing substituters, disk space, or another environmental
limitation, report it as `blocked` or `skipped`, not `passed`.

Warnings do not automatically mean failure. Determine whether each warning is
pre-existing, unrelated, or introduced by the current changes.

## Reporting

Group the final report into:

- Changed files.
- Validation level used.
- Commands executed.
- Passed checks.
- Failed checks.
- Warnings.
- Unrelated pre-existing failures.
- Evaluated or built outputs.
- Recommended follow-up actions.

For every failure, include:

- The command that failed.
- The relevant file or output.
- A concise explanation.
- Whether the failure appears related to the current changes.

Distinguish clearly between:

```text
passed
failed
skipped
not applicable
blocked
```

Do not claim that validation passed unless the command actually completed
successfully.
