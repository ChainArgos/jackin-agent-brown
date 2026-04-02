# agent-brown

`agent-brown` is the ChainArgos `jackin` agent. It provides the agent-specific environment layer for the ChainArgos Java/Rust monorepo.

`jackin` validates this repo's Dockerfile, derives the final image itself, and mounts the cached repo checkout into `/workspace` when you run:

```sh
jackin load chainargos/agent-brown
```

## Contract

- Final Dockerfile stage must literally be `FROM donbeave/jackin-construct:trixie`
- Plugins are declared in `jackin.agent.toml`

## Environment

- **Node.js** LTS (via mise)
- **Rust** latest (via mise)
- **Java** Oracle GraalVM 25.0.1 (via mise)
- **Protobuf compiler** (via mise)
- **GitHub CLI** (gh)
- **Cargo tools:** cargo-nextest, ast-grep, rust-script, just, shellfirm, tirith, bottom
- **Tessl CLI**
- **SpecStory CLI**
- **ctx7** (npm)

Shared shell/runtime tools come from `jackin-construct:trixie`.
