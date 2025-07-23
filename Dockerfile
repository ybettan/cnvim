FROM fedora:42

RUN dnf -y update && \
    dnf -y install \
        make \
        git \
        golang \
        neovim

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; \
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

WORKDIR /mnt

ENTRYPOINT [ "nvim" ]
