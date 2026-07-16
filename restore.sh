#!/bin/bash

set -e

echo "🚀 Iniciando restauração do sistema..."

# 1. Instalar paru
if ! command -v paru &> /dev/null; then
    echo "📦 Instalando paru..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si
    cd ~
fi

# 2. Instalar pacotes oficiais
echo "📦 Instalando pacotes oficiais..."
sudo pacman -S --needed - < ~/dotfiles/pkglist_official.txt

# 3. Instalar pacotes AUR
echo "📦 Instalando pacotes AUR..."
paru -S --needed - < ~/dotfiles/pkglist_aur.txt

# 4. Instalar flatpaks (se existir)
if [ -s ~/dotfiles/flatpak_list.txt ]; then
    echo "📦 Instalando flatpaks..."
    flatpak install -y --from ~/dotfiles/flatpak_list.txt
fi

# 5. Aplicar dotfiles com Stow
echo "🔗 Aplicando dotfiles com Stow..."
cd ~/dotfiles
stow -v --restow .

# 6. Restaurar tema SDDM Pixie com assets
if [ -d ~/dotfiles/system/sddm/themes/pixie/assets ]; then
    echo "🖼️ Restaurando tema SDDM Pixie..."
    # Garante que o tema está instalado
    if [ ! -d /usr/share/sddm/themes/pixie ]; then
        paru -S --needed pixie-sddm-git 2>/dev/null || sudo pacman -S pixie-sddm-git
    fi
    # Copia os assets
    sudo cp -r ~/dotfiles/system/sddm/themes/pixie/assets/* /usr/share/sddm/themes/pixie/assets/
    echo "   ✓ Tema Pixie restaurado"
fi

# 7. Restaurar papéis de parede
if [ -d ~/dotfiles/system/wallpapers/Wallpapers ]; then
    echo "🖼️ Restaurando papéis de parede..."
    mkdir -p ~/Imagens
    cp -r ~/dotfiles/system/wallpapers/Wallpapers/* ~/Imagens/Wallpapers/
    echo "   ✓ Papéis de parede restaurados"
fi

# 8. Restaurar avatar
if [ -f ~/dotfiles/system/avatar/avatar.jpg ]; then
    echo "👤 Restaurando avatar..."
    cp ~/dotfiles/system/avatar/avatar.jpg ~/.face
    echo "   ✓ Avatar restaurado"
fi

# 9. Recarregar Niri
echo "🔄 Recarregando Niri..."
niri msg action reload-config 2>/dev/null || echo "ℹ️ Reinicie o Niri manualmente"

# 10. Configurar shell
echo "⚙️ Configurando Zsh..."
chsh -s /usr/bin/zsh
if [ ! -d ~/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
fi

echo "✅ Restauração concluída! Reinicie o sistema: sudo reboot"
