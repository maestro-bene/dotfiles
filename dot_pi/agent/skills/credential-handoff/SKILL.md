---
name: credential-handoff
description: Safely handle commands that may require a GPG/YubiKey PIN, passphrase, signing key, or interactive authentication unavailable to Pi. Use before chezmoi operations involving encrypted data, signed Git commits/tags, or other commands that may prompt for hardware-backed credentials.
---

# Credential-dependent command handoff

Use this workflow when a command may need a secret, a hardware key, a pinentry prompt, or interactive authentication that may not be available in Pi's shell.

## Non-negotiable rules

- Never ask the user to send a PIN, passphrase, password, recovery code, private key, or authentication token in chat.
- Never put secrets in a command, script, environment variable, temporary file, stdin, or tool call. Do not use options such as `--passphrase` or `pinentry-mode loopback` to work around a blocked prompt.
- Do not repeatedly retry after a credential or pinentry failure. In particular, stop on `Bad PIN`, missing-card, signing, decryption, or agent errors; repeated PIN attempts can lock a hardware key.
- Do not disable signing, encryption, hooks, or security checks, or change GPG/SSH configuration merely to make the command succeed.
- Keep the user in control of any operation that needs their private key or interactive approval.

## Workflow

1. **Identify the likely prompt before running the command.** Examples include:
   - `chezmoi status`, `diff`, `apply`, `execute-template`, or similar operations when templates or managed files need GPG decryption;
   - `git commit`, signed tags, or other Git operations that invoke commit/tag signing or a hook requiring a key;
   - direct GPG signing/decryption, and SSH operations that require a hardware-backed key, touch, PIN, or agent confirmation.
2. **Do all safe preparation first.** Inspect the relevant files and configuration, check the working-tree diff/status when possible without triggering decryption, and run checks that do not need credentials. For changes, show the user what would be affected. Never apply chezmoi changes to the target home directory without the user's explicit approval.
3. **Hand off instead of prompting for a secret.** Tell the user which credential/key is needed and ask them to insert/unlock the key if appropriate. Give the exact command to run in their own trusted terminal, with the required working directory. Do not ask them to paste secret input or pinentry contents. For destructive or broad operations, first show the exact command and its scope and obtain approval.
4. **Wait for confirmation.** Ask the user to report whether it succeeded and, if useful, share only non-sensitive output or the exit status. Once confirmed, continue with non-credential-dependent checks. If the operation still fails, stop and help diagnose from sanitized error output; do not guess PINs or retry automatically.
5. **Record the boundary clearly.** State which steps Pi completed and which the user ran, so no credential-dependent operation is assumed to have succeeded.

## Practical examples

- If a chezmoi inspection fails with a GPG decryption error, stop. Explain that the encrypted source requires the user's YubiKey, then ask them to run the specific chezmoi command in their terminal with the key inserted. Resume only after they confirm the result.
- Before a signed Git commit, prepare and review the staged diff, then provide the commit command for the user to run in their terminal. Do not silently switch to an unsigned commit.
- If a GPG or SSH prompt appears to hang or is inaccessible from Pi, stop the command rather than sending input blindly. The user can run it in a terminal where their trusted pinentry/agent and hardware key are available.

This workflow is a handoff, not a request for the user to disclose credentials.