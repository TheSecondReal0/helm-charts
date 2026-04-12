# Hermes Agent Helm Chart Design

Date: 2026-04-12

## Context
We want a Helm chart that mirrors the Hermes Agent Docker gateway setup. The repo already has per-app charts under `apps/` that use a simple pattern: Deployment/StatefulSet, Service, HTTPRoute, and PVC. We will follow those patterns while adapting to Hermes requirements.

References in repo:
- `apps/searxng` for HTTPRoute and basic values layout
- `apps/vikunja` for PVC patterns and environment wiring

## Goals
- Provide a single chart to run Hermes Agent in gateway mode
- Use a StatefulSet with a PVC at `/opt/data` as the single source of truth
- Keep the image tag pinned (no `latest`) for manual/renovate upgrades
- Route traffic through Gateway API (HTTPRoute) like existing apps

## Non-Goals
- No ExternalSecrets or Secret generation by default
- No automated setup job; setup is run manually by operators
- No multi-replica support (Hermes data directory is single-writer)

## Proposed Chart
Location: `apps/hermes-agent/`

Resources:
- StatefulSet (replicas: 1)
- Service (ClusterIP)
- PVC for `/opt/data`
- HTTPRoute to `traefik-gateway` in namespace `traefik`

Container behavior:
- Image: `nousresearch/hermes-agent:<pinned-tag>`
- Command/args: `gateway run`
- Optional extra env/args via values (default empty)
- Mount PVC at `/opt/data`

Manual setup flow:
1. Deploy chart
2. Exec into the pod and run `hermes setup` (interactive wizard)
3. The setup writes `/opt/data/.env` and config files to the PVC
4. Restart the pod if needed to pick up new config

## Values (draft)
```
image:
  repository: nousresearch/hermes-agent
  tag: 1.0.0

service:
  host: hermes.example.com

persistence:
  size: 2Gi
  storageClassName: ""

resources: {}

extraEnv: []
extraArgs: []

httproute:
  gatewayName: traefik-gateway
  gatewayNamespace: traefik
  sectionName: web
```

## Templates
- `statefulset.yaml` with PVC volumeMount at `/opt/data`
- `pvc.yaml` for persistent storage
- `service.yaml` for internal access
- `httproute.yaml` matching the `apps/searxng` pattern

## Operational Notes
- Keep replicas at 1 to avoid concurrent access to `/opt/data`
- Upgrades: bump image tag in values and redeploy
- Troubleshooting: `kubectl logs` and `kubectl exec` for `hermes version`

## Testing
- `helm template` to validate rendered manifests
- Deploy to a non-prod namespace and verify HTTPRoute, PVC mount, and gateway startup
