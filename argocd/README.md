```bash
argocd app create learn-talos --repo https://github.com/i544c-me/learn-talos.git --path argocd/apps --dest-server https://kubernetes.default.svc --dest-namespace default
```
