setup-flatpaks:
  #!/usr/bin/env bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done


nix-me-up:
  echo 'Setting phasers to kill. Installing nix.'
  /usr/bin/ublue-nix-install

nix-devbox:
  echo 'Installing devbox!'
  curl -fsSL https://get.jetpack.io/devbox | bash

distrobox-bluefin:
  echo 'Creating Blufin Ubuntu distrobox ...'
  distrobox create --image ghcr.io/ublue-os/ubuntu-toolbox:latest -n bluefin -Y

distrobox-universal:
  echo 'Creating Universal Development distrobox ...'
  distrobox create --image mcr.microsoft.com/devcontainers/universal:latest -n universal -Y
 
  
distrobox-fedoraboxkit:
  echo 'Creating Fedora distrobox'
  distrobox create --image ghcr.io/odintdh/fedoraboxkit:latest  -n fedoraboxkit -Y

distrobox-devopsbox:
  echo 'Creating Fedora devops'
  distrobox create --image ghcr.io/odintdh/boxkit:latest -n devops -Y


upgrade:
  rpm-ostree upgrade
  flatpak update -y
  distrobox upgrade -a

yafti:
  yafti /usr/share/ublue-os/firstboot/yafti.yml
