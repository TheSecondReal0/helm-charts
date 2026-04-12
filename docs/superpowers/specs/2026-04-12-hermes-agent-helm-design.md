# Hermes Agent Helm Chart Design (Simplified)

Date: 2026-04-12

## Goal
Create a single Helm chart to run Hermes Agent in gateway mode, based on the Docker setup, following patterns in `apps/`.

## Chart Scope
Location: `apps/hermes-agent/`

Resources:
- StatefulSet (replicas: 1)
- Headless Service for StatefulSet identity (`<release>-headless`)
- ClusterIP Service for HTTPRoute traffic (`<release>`)
- PVC via StatefulSet `volumeClaimTemplates` mounted at `/opt/data`
- HTTPRoute to `traefik-gateway` (Gateway API v1)

## Runtime Behavior
- Image: `nousresearch/hermes-agent:<pinned-tag>` (no `latest`)
- Command/args: `command: ["hermes"]`, `args: ["gateway","run", ...extraArgs]`
- PVC mounted at `/opt/data` (Hermes data dir)
- Exposes HTTP port 8080 by default
- Service exposes port 80 and targets container port 8080 (repo pattern)
- `imagePullPolicy: IfNotPresent`
- `enableServiceLinks: false`

## Manual Setup
- Deploy chart
- Run `hermes setup` inside the pod once (interactive)
- Restart pod to pick up `/opt/data/.env` changes

## Values (minimum)
```
image:
  repository: nousresearch/hermes-agent
  tag: 1.0.0

service:
  host: hermes.example.com
  port: 80
  targetPort: 8080

persistence:
  size: 2Gi
  storageClassName: ""
  accessModes:
    - ReadWriteOnce

resources: {}

extraEnv: []   # list of EnvVar objects
extraArgs: []  # list of string args appended to default args

httproute:
  enabled: true
  gatewayName: traefik-gateway
  gatewayNamespace: traefik
  sectionName: web
```

## Templates
- `statefulset.yaml`: 1 replica, `serviceName: <release>-headless`, PVC mount at `/opt/data`, container port 8080
- `service-headless.yaml`: headless service (`clusterIP: None`)
- `service.yaml`: ClusterIP service with `port` and `targetPort`
- `httproute.yaml`: HTTPRoute using `service.host` and `service.port`
- Omit `storageClassName` when the value is empty
- `volumeClaimTemplates` uses `metadata.name: data` and the mount uses `name: data`
- Labels/selectors use `app: {{ .Release.Name }}` consistently
- `httproute.yaml` is only rendered when `httproute.enabled` is true

## Notes
- ExternalSecrets are not used
- Single replica only (Hermes data dir is single-writer)
- `service.host` must be set to your real hostname when HTTPRoute is enabled

## Chart Metadata
- `Chart.yaml` name: `hermes-agent`
- `Chart.yaml` version: `0.1.0`
- `Chart.yaml` appVersion matches the pinned image tag
