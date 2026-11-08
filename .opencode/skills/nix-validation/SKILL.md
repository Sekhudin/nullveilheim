---
name: Nix Validation
description: Validate Nix configuration changes with formatting, diff checks, evaluation, and builds
---

# Nix Validation

Use this skill after modifying Nix files or flake configuration.

## Safety Rules

- Read and follow the repository's `AGENTS.md`.
- Do not read, decrypt, modify, or remove files under `secrets/`.
- Do not modify `.sops.yaml`.
- Do not apply automatic fixes unless explicitly requested.
- Do not commit or push changes.
- Do not run system-wide commands such as `nixos-rebuild switch` or
  `darwin-rebuild switch`.

## Workflow

1. Inspect the current Git status and diff.
2. Identify the changed Nix files and affected configuration.
3. Run the relevant formatter check, such as:

   ```sh
   nixfmt --check path/to/changed-file.nix
   ```

4. Check for whitespace errors:

   ```sh
   git diff --check
   ```

5. Run flake validation when applicable:

   ```sh
   nix flake check
   ```

6. Evaluate or build the affected configuration when practical.
7. Review the final diff for unintended changes.
8. Report the results clearly.

## Reporting

Group results into:

- Passed checks
- Failed checks
- Warnings
- Unrelated pre-existing failures
- Recommended follow-up actions

For every failure, include:

- The command that failed
- The relevant file or configuration
- A concise explanation
- Whether the failure appears related to the current changes

Do not claim that validation passed unless the command actually completed successfully.
