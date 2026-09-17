# ricochet

See the Chart README at [charts/ricochet/README.md](charts/ricochet/README.md)

## Cluster RBAC upgrades

With `rbac.clusterRole.enabled: true`, each installation creates a ClusterRole and ClusterRoleBinding named `<namespace>.<release>`.
Deployments, Services, service accounts, and PVCs retain their existing names.

When upgrading installations that share the old `ricochet` ClusterRole or ClusterRoleBinding, pause automated sync and pruning for all affected Argo CD Applications first.
Sync the upgrades without pruning, verify that every installation has its new role and binding, then remove the old shared RBAC objects and restore automated sync and pruning.
This keeps an upgraded installation from deleting permissions still needed by an installation on the old chart.
