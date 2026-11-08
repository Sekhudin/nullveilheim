# Project Instructions

## Project Scope

This repository contains personal NixOS, nix-darwin, and Home Manager
configurations managed with Nix flakes.

Treat this repository as a personal infrastructure configuration project.
Preserve existing structure, naming conventions, and module boundaries.

## Safety Rules

- Do not read, decrypt, modify, or remove files under `secrets/` unless explicitly requested.
- `.sops.yaml` may be read when necessary to understand the repository's
  secret-management configuration.
- Do not modify `.sops.yaml` without explicit approval.
- Never include decrypted secret values in logs, prompts, diffs, or responses.
- Never expose secret values, credentials, private keys, tokens, or sensitive machine data.
- Do not run destructive commands such as `git reset --hard`, broad recursive deletion,
  or force-push operations unless explicitly requested.
- Do not commit or push changes without explicit user approval.
- Do not modify unrelated files or discard existing user changes.
- Ask for confirmation before applying system-wide changes.

## Git Workflow

- Do development work on a dedicated branch, not directly on `main`.
- Keep changes focused and reviewable.
- Inspect the working tree before making changes.
- Review the complete diff before committing.
- Use clear Conventional Commit messages.
- Do not rewrite published history.
- Pull requests should target `main`.
- CI must pass before merging.

## Nix Conventions

- Preserve the existing modular structure.
- Prefer reusable modules and existing helpers over duplicated configuration.
- Keep host-specific configuration under `configurations/`.
- Keep reusable behavior under `modules/`.
- Keep flake-level packages, overlays, shells, and services under `parts/`.
- Use the existing `shared/` helpers when applicable.
- Do not hardcode secrets or machine-specific values without a clear reason.
- Preserve compatibility across supported Linux and macOS configurations when possible.

## Validation

After changing Nix files:

1. Run the relevant formatter.
2. Run `git diff --check`.
3. Run `nix flake check` when applicable.
4. Build or evaluate the affected configuration when practical.
5. Report validation results and any unrelated pre-existing failures.

Do not claim a change is complete without reviewing the resulting diff.

## AI Development Workflow

Before editing:

1. Understand the request and inspect the relevant files.
2. Create a short implementation plan.
3. Identify possible risks and affected configurations.

During implementation:

- Make the smallest change that solves the task.
- Preserve unrelated work in the working tree.
- Prefer explicit, maintainable configuration over clever abstractions.
- Ask questions when requirements or scope are ambiguous.

Before completion:

- Review the diff.
- Run appropriate validation.
- Summarize changed files, tests, and known limitations.
- Wait for explicit approval before committing or pushing.
