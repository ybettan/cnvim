FROM fedora:42

RUN dnf -y update && \
    dnf -y install \
        make \
        git \
        golang \
        neovim

WORKDIR /mnt

ENTRYPOINT [ "nvim" ]
