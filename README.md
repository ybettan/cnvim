# cnvim

### Setup
Add the following alias to use `cnvim` with Podman:
```bash
alias cnvim='eval "podman run -it --rm -v /home/ybettan/go/src/github.com/cnvim/nvim:/root/.config/nvim:z -v /home/ybettan/.local/share/nvim:/root/.local/share/nvim:z -v /home/ybettan/go/bin:/root/go/bin:z -v /home/ybettan/go/pkg:/root/go/pkg:z -v /home/ybettan/.config/github-copilot/apps.json:/root/.config/github-copilot/apps.json -v $(pwd):/mnt quay.io/ybettan/cnvim:latest"'
```

If you change the Dockerfile, Run the following commands to rebuild cnvim:

```bash
podman build -t quay.io/ybettan/cnvim:latest .
podman push quay.io/ybettan/cnvim:latest
```
