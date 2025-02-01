```bash
argocd app create apps \
  --repo https://github.com/i544c-me/learn-talos.git --path argocd/apps --revision staging \
  --dest-server https://kubernetes.default.svc --dest-namespace default \
  --sync-policy automated --auto-prune --self-heal
```
