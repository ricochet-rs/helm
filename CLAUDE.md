# Required Ricochet instructions

Before inspecting repository files, planning, editing, or running project commands, ensure the shared instructions are available.

1. Use `~/.cache/ricochet-rs/agent-instructions` as the shared checkout.
2. If the checkout is absent, clone `https://github.com/ricochet-rs/agent-instructions.git` there.
3. Fetch `origin/main` and check it out in detached-HEAD mode.
4. Verify that cached `HEAD` exactly matches `origin/main`.
5. Read `instructions/global.md`.
6. Read and follow `skills/development-flow/SKILL.md` for code changes.

The shared skills may not appear in the startup skill catalog.
Read their `SKILL.md` files directly from the shared checkout and follow them for the current session.

If authentication, synchronization, HEAD validation, or a required read fails, stop before modifying the repository and report the failure clearly.
Do not silently continue with missing or stale shared instructions.

## Repository instructions

### Chart version

Never edit `version` in `Chart.yaml`.
A bot bumps it with `appVersion` when Ricochet releases, so a hand-written bump collides with that commit.

### Regenerating the values table

Run `just docs`, never `helm-docs` alone.
The recipe pairs it with `prettier`, which pads the table's columns, so `helm-docs` on its own rewrites all 250 rows and buries the two that changed.

### Adding a Ricochet configuration key

Add nothing.
`config.backend` and every `config.<section>` render into the TOML verbatim, so a new key in Ricochet reaches the chart without a template change; only a value the chart itself derives, such as a claim name, needs one.

### Running the chart tests

Run `just test`, and read a failure against `origin/main` before believing it.
CI pins the Helm and `helm-unittest` versions in `.crow/test.yaml`, and an older pair fails suites here that pass there, so the count that matters is whether the branch adds failures rather than whether it has none.

### Cluster-scoped permissions

Put a cluster-scoped rule in `templates/clusterrole.yaml`, which is gated behind `rbac.clusterRole.enabled` and off by default.
Ricochet treats a forbidden read as a missing object, so a feature that depends on one degrades silently rather than reporting the permission it lacks: say so in the values comment, since the operator is the one who has to turn it on.
