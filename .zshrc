# ═══════════════════════════════════════════════════════════
# 1. FASTFETCH PRIMEIRO (antes de tudo)
# ═══════════════════════════════════════════════════════════
fastfetch --config ~/.config/fastfetch/config.jsonc

# ═══════════════════════════════════════════════════════════
# 2. DEPOIS o Instant Prompt do Powerlevel10k
# ═══════════════════════════════════════════════════════════
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ═══════════════════════════════════════════════════════════
# 3. RESTO DAS CONFIGURAÇÕES (source do cachyos, p10k, etc)
# ═══════════════════════════════════════════════════════════
source /usr/share/cachyos-zsh-config/cachyos-config.zsh
. "$HOME/.local/bin/env"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
limpeza() {
    echo "🧹 Removendo pacotes órfãos..."
    sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null
    echo "📦 Limpando cache do pacman..."
    sudo paccache -rvk3
    echo "📦 Limpando cache do paru..."
    paru -Scc
    echo "📄 Limpando logs antigos..."
    sudo journalctl --vacuum-time=3days
    echo "🗑️ Esvaziando Lixeira"
    sudo rm -rf ~/.local/share/Trash/files/* ~/.local/share/Trash/info/
    trash-empty
    echo "📋 Lista de Snapps para delete --sync"
    sudo snapper list
}
