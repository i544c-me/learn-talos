```bash
talosctl gen config learn-talos https://192.0.2.1:6443

talosctl apply-config --insecure -n 192.0.2.1 --file controlplane.yaml
talosctl apply-config --insecure -n 192.0.2.101 --file worker.yaml
talosctl bootstrap -n 192.168.0.1 -e 192.168.0.1 --talosconfig=./talosconfig
```

## TODO

この設定ファイルをどう管理するか考える。絶対に plain な状態で git 管理はしたくない。
