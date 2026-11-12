# Development

> Scope: validating and extending the repository, not installing a host.

Development should be done on a focused branch and validated before opening a
pull request. This repository is personal infrastructure built with
[flake-parts](https://flake.parts/), [ez-configs](https://flake.parts/options/ez-configs.html),
[Home Manager](https://home-manager.dev/manual/26.05/), and
[sops-nix](https://github.com/Mic92/sops-nix), so changes should
preserve existing module boundaries and avoid unrelated modifications.

## Useful Commands

Inspect flake outputs:

```sh
nix flake show
```

Run all flake checks and systems:

```sh
nix flake check --all-systems
```

Check the Git diff for whitespace errors:

```sh
git diff --check
```

Check Nix formatting:

```sh
nixfmt --check path/to/file.nix
```

Build or evaluate an output:

```sh
nix build .#nixvim
nix eval --raw .#nixosConfigurations.t14.config.system.stateVersion
```

Use `nix build .#<output>` and `nix eval .#<output>` for other outputs when
the target is available on the current system.

## Development Shells

The flake provides a default shell and language-specific shells:

```sh
nix develop
nix develop .#go
nix develop .#nodejs24
nix develop .#bun
nix develop .#c-linux
```

The default shell includes pre-commit checks for GitHub Actions, shell
scripts, Lua, dead Nix code, and Nix formatting.

## Change Workflow

1. Start from an up-to-date `main` branch.
2. Create a focused branch, such as `fix/...`, `feat/...`, or `docs/...`.
3. Inspect the relevant modules and existing conventions.
4. Implement the smallest change that solves the problem.
5. Run formatting, `git diff --check`, and the relevant flake checks.
6. Review the complete diff, including documentation links and examples.
7. Open a pull request targeting `main`.
8. Wait for CI and review feedback.
9. Squash-merge after approval.

Do not commit or push without explicit approval when working interactively.
Do not rewrite published history or discard unrelated user changes.

## Secrets and Safety

- Do not read, decrypt, or expose files under `secrets/` unless explicitly required.
- Never include decrypted secret values, credentials, tokens, or private keys in a diff.
- Keep `.sops.yaml` unchanged unless the change is explicitly requested.
- Test secret-dependent activation only in a safe environment.
- Ask for confirmation before applying system-wide changes.

## Validation Checklist

Before considering a change complete:

```sh
nixfmt --check path/to/changed.nix
git diff --check
nix flake check --all-systems
git diff --stat
git status --short --branch
```

If a check is skipped, blocked, or times out, report that clearly instead of
claiming that validation passed.

## Library References

- [flake-parts documentation](https://flake.parts/)
- [ez-configs options](https://flake.parts/options/ez-configs.html)
- [Home Manager manual](https://home-manager.dev/manual/26.05/)
- [sops-nix documentation](https://github.com/Mic92/sops-nix)
- [Nixpkgs library manual](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library)

[← Back to README](../README.md)
