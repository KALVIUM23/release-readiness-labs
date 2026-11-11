# Release Readiness Pack: OrderFlow v2.3.0

## 1. Release Metadata
- **Release Version**: v2.3.0
- **Git Commit SHA / Tag**: v2.3.0 (`9166599`)
- **Docker Image**: orderflow:v2.3.0 (lab-app:v2.3.0)
- **Target Environment**: Production
- **Release Engineer**: Sagar

---

## 2. Issues Discovered & Remediation Summary

| Area | Original Issue | Impact | Resolution |
| :--- | :--- | :--- | :--- |
| **Pipeline** | `deploy-production` ran without `needs: [lint-and-test, build-image]` | Untested code could reach production | Added strict dependencies (`needs: [lint-and-test, build-image]`) |
| **Secrets** | Hardcoded secrets / plain values in manifests & config | Risk of credential exposure | Moved secrets to GitHub Secrets & K8s `secretKeyRef` |
| **Kubernetes** | Service selector / YAML indentation in `secretKeyRef` | Pod initialization failure or routing mismatch (503 / no endpoints) | Corrected `secretKeyRef` syntax and verified selector alignment (`app: lab-app`) |
| **Tagging** | Used non-traceable `:latest` / unversioned tags | Cannot correlate deployment to Git commit | Tagged explicitly with semantic version `v2.3.0` |

---

## 3. Infrastructure & Architecture Decision
- **Terraform vs Kubernetes**: Terraform is selected to declaratively provision and manage underlying cloud infrastructure (VPC, cloud subnets, IAM roles, and the Kubernetes cluster itself). Kubernetes is selected to manage and orchestrate the runtime containerized application workloads (Pods, Deployments, Services, and scaling policies).

---

## 4. Deployment & Approval Gates
- **Validation Sequence**: Lint & Test $\rightarrow$ Build Artifact $\rightarrow$ Staging Validation $\rightarrow$ Environment Gate $\rightarrow$ Production Deploy $\rightarrow$ Smoke Test.
- **Manual Gate**: GitHub Environment `production` requires explicit approval from designated Release Approvers before deployment execution begins.

---

## 5. Rollback Strategy
### Rollback Triggers:
1. Application crashloop backoff or unready Pod health checks (`/health` returning non-200).
2. Production error rate (HTTP 5xx) exceeding 1% within 10 minutes post-deployment.

### Rollback Action:
- Immediate execution of `kubectl rollout undo deployment/lab-app` to revert to previous stable revision (`v2.2.0`), or trigger automated rollback script `./scripts/rollback.sh v2.2.0`.

---

## 6. Final Release Decision
- **Status**: **READY FOR PRODUCTION**
- **Justification**: All pipeline security checks pass, environment approval gates are enforced, secrets are secured, manifests route traffic correctly, and a rollback plan is verified.
