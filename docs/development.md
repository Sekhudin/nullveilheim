# Development

This guide explains how to develop the repository, check your changes, and
open a pull request. Host installation is covered in
[Hosts](hosts.md).

The repository uses [Nix flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake),
[flake-parts](https://flake.parts/),
[ez-configs](https://flake.parts/options/ez-configs.html),
[Home Manager](https://home-manager.dev/manual/26.05/), and
[sops-nix](https://github.com/Mic92/sops-nix). Before changing a module, look
at nearby files and follow the patterns already used in the repository.

## Inspecting the Repository

To see the outputs provided by the flake:

```sh
nix flake show
```

To check the current diff for whitespace errors:

```sh
git diff --check
```

To check the formatting of a Nix file:

```sh
nixfmt --check path/to/file.nix
```

## Running Validation

The checks you need depend on the type of change.

### Documentation-only changes

For changes to README or Markdown files, run:

```sh
git diff --check
```

### Nix and configuration changes

For changes to Nix modules, packages, overlays, flake inputs, or host
configurations, run:

```sh
nixfmt --check path/to/changed.nix
git diff --check
nix flake check --all-systems
```

When a change affects a particular output, evaluate or build that output when
practical:

```sh
nix eval .#<output>
nix build .#<output>
```

Run `nix flake show` first and replace `<output>` with an output that actually
exists in the flake.

## Development Shells

The flake provides a default shell and language-specific shells:

```sh
nix develop
nix develop .#go
nix develop .#nodejs24
nix develop .#bun
nix develop .#c-linux
```

The default shell installs the repository's pre-commit checks. They cover
GitHub Actions, shell scripts, Lua, dead Nix code, and Nix formatting.

## Change Workflow

1. Update your local `main` branch.
2. Create a branch for the change, such as `docs/...`, `fix/...`, or `feat/...`.
3. Look for existing examples and conventions before adding new configuration.
4. Make the smallest change that solves the problem.
5. Run the validation appropriate for the files you changed.
6. Review the complete diff and confirm that no unrelated files changed.
7. Create a commit with a clear message.
8. Push the branch and open a pull request targeting `main`.
9. Wait for CI and review feedback before merging.

## Secrets and System Changes

Do not include secret values, credentials, tokens, or private keys in commits or
documentation.

Files under `secrets/` and `.sops.yaml` should only be changed when they are
directly part of the work. Test secret-dependent activation in a safe
environment.

Before applying a system configuration, review the target host and the build
result carefully. Do not switch a system using an unreviewed configuration.

## Before Opening a Pull Request

- Make sure the branch started from an up-to-date `main`.
- Review the complete diff.
- Confirm that only intended files changed.
- Run the checks appropriate for the change.
- Check documentation links and configuration examples.
- Confirm that CI passes.
- Explain any check that could not be run.

## Issue and Pull Request Conventions

Create one issue or pull request per problem or change. Use the templates in
`.github/` as a starting point.

Issue forms are rendered by the GitHub web UI. When using `gh issue create`,
use `--web` to open the form, or provide a title and body manually. Add labels
manually with `--label`. To start a pull request from the template, use
`gh pr create --template .github/pull_request_template.md`.

### Branch Names

| Change | Pattern | Example |
| --- | --- | --- |
| Bug fix for an issue | `fix/issue-<number>` | `fix/issue-25` |
| Feature for an issue | `feat/issue-<number>` | `feat/issue-25` |
| Documentation | `docs/<description>` | `docs/home-manager-options` |
| Refactor | `refactor/<description>` | `refactor/agent-module` |
| Maintenance | `chore/<description>` | `chore/pr-issue-templates` |

### Pull Requests

- Target `main`.
- Use a Conventional Commit title because squash merge uses it as the commit
  subject.
- Link the related issue with `Closes #<number>`.
- Keep the change focused and unrelated edits out of the PR.
- Fill in the validation checklist and mention any check that was skipped.
- Do not include secret values, tokens, or private keys.

Examples:

```text
fix(noctalia): correct dock toggle
feat(home): add agent module
docs: update activation defaults
```

### Issues

Use the bug report, feature request, or documentation form that matches the
request. Include the affected host, profile, and module. Paste relevant command
output after removing sensitive values.

## Useful Evaluation Examples

Evaluate a host option:

```sh
nix eval --raw .#nixosConfigurations.t14.config.system.stateVersion
```

Build a Home Manager activation package:

```sh
nix build '.#homeConfigurations."syaikhu@t14".activationPackage'
```

Build or evaluate another output with its exact flake path:

```sh
nix build .#nixvim
nix eval .#<output>
```

Run `nix flake show` first when you need to find the exact output name.

## Library References

- [flake-parts documentation](https://flake.parts/)
- [ez-configs options](https://flake.parts/options/ez-configs.html)
- [Home Manager manual](https://home-manager.dev/manual/26.05/)
- [sops-nix documentation](https://github.com/Mic92/sops-nix)
- [Nixpkgs library manual](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library)

[← Back to README](../README.md)
