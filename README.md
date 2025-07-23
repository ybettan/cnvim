# cnvim

### Setup
Add the following alias to use `cnvim` with Podman:
```bash
alias cnvim="podman run -it --rm -v /home/ybettan/go/src/github.com/cnvim/init.vim:/root/.config/nvim/init.vim:z -v /home/ybettan/go/src/github.com/cnvim/nvim-plugins:/root/.local/share/nvim:z -v /home/ybettan/go/src/github.com/cnvim/vim-plugins:/root/.vim:z -v /home/ybettan/go/bin:/root/go/bin:z -v /home/ybettan/go/pkg:/root/go/pkg:z -v $(pwd):/mnt quay.io/ybettan/cnvim:latest"
```

If you change the Dockerfile, Run the following commands to rebuild cnvim:

```bash
podman build -t quay.io/ybettan/cnvim:latest .
podman push quay.io/ybettan/cnvim:latest
```
