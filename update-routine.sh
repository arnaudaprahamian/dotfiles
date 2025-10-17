#!/bin/bash

# --- Configuration ---
# Liste des dossiers où exécuter 'git pull'
# Assurez-vous que ces dossiers existent et sont des dépôts Git.
GIT_DIRS=("$HOME/.pyenv" "$HOME/.rbenv" "$HOME/.goenv" "$HOME/.oh-my-zsh" "$HOME/.phpenv" "$HOME/.tfenv")
# Vous pouvez ajouter d'autres chemins si nécessaire, par exemple "$HOME/mon_projet_git"
# N'oubliez pas d'enlever les chemins que vous n'avez pas.

# --- Fonction pour les mises à jour Apt ---
update_apt() {
    echo "========================================="
    echo "🚀 Démarrage de la mise à jour des paquets APT..."
    echo "========================================="
    # Lancement des commandes apt
    sudo apt update && sudo apt upgrade -y
    if [ $? -eq 0 ]; then
        echo "✅ Mises à jour APT terminées avec succès."
    else
        echo "❌ Erreur lors des mises à jour APT. Veuillez vérifier les messages ci-dessus."
    fi
}

# --- Fonction pour les mises à jour Homebrew ---
update_brew() {
    # Vérifie si Homebrew est installé
    if command -v brew &> /dev/null; then
        echo "========================================="
        echo "🍺 Démarrage de la mise à jour Homebrew (brew)..."
        echo "========================================="
        # Lancement des commandes brew
        brew update
        brew upgrade
        if [ $? -eq 0 ]; then
            echo "✅ Mises à jour Homebrew terminées avec succès."
        else
            echo "⚠️ Avertissement : Problème potentiel avec les mises à jour Homebrew."
        fi
    else
        echo "========================================="
        echo "➖ Homebrew n'est pas trouvé. Saut de l'étape Homebrew."
        echo "========================================="
    fi
}

# --- Fonction pour les git pull des dépôts locaux ---
update_git_repos() {
    echo "========================================="
    echo "⚙️ Démarrage de la mise à jour des dépôts Git locaux..."
    echo "========================================="
    local errors=0
    for dir in "${GIT_DIRS[@]}"; do
        if [ -d "$dir" ] && [ -d "$dir/.git" ]; then
            echo "-> Mise à jour de $dir..."
            (cd "$dir" && git pull)
            if [ $? -ne 0 ]; then
                echo "❌ Erreur de 'git pull' dans $dir."
                errors=$((errors + 1))
            fi
        elif [ -d "$dir" ]; then
             echo "⚠️ $dir existe mais ne semble pas être un dépôt Git. Ignoré."
        else
            echo "⚠️ Le chemin $dir n'existe pas. Ignoré."
        fi
    done

    if [ $errors -eq 0 ]; then
        echo "✅ Tous les dépôts Git configurés ont été mis à jour avec succès (si existants)."
    else
        echo "⚠️ $errors erreur(s) de 'git pull' détectée(s)."
    fi
}

# --- Exécution Séquentielle des Fonctions ---
main() {
    echo "========================================="
    echo "🔄 Début de la Routine de Mise à Jour Complète sur Ubuntu/WSL"
    echo "========================================="

    update_apt

    update_brew

    update_git_repos

    echo "========================================="
    echo "🎉 Routine de Mise à Jour Complète Terminée !"
    echo "========================================="
}

# Lancement de la fonction principale
main