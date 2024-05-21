#!/bin/bash

script_dir() {
    if [ -z "${SCRIPT_DIR}" ]; then
        # Even resolves symlinks, see
        # http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
        local SOURCE="${BASH_SOURCE[0]}"
        while [ -h "$SOURCE" ]; do SOURCE="$(readlink "$SOURCE")"; done
        SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    fi
    echo "${SCRIPT_DIR}"
}

CODE_HOME=$(script_dir)

setup_file_link() {
    local source="$1"
    local destination="$2"
    if [ ! -e "${destination}" ]; then
        ln -nfs "${source}" "${destination}" && echo "Linked file ${source} to ${destination}" >> "$LOG_FILE"
    else
        echo "ERROR: File ${destination} already exists" >> "$LOG_FILE"
    fi
}

setup_dir_link() {
    local source="$1"
    local destination="$2"
    if [ ! -d "${destination}" ]; then
        ln -s "${source}" "${destination}" && echo "Linked directory ${source} to ${destination}" >> "$LOG_FILE"
    else
        echo "ERROR: Directory ${destination} already exists" >> "$LOG_FILE"
    fi
}

LOG_FILE="${CODE_HOME}/install/install.log"
echo "Installation started at $(date)" > "$LOG_FILE"

# Create backup dir if it doesn't exist
if [ ! -d "${HOME}/.backup" ]; then
    echo "Creating ~/.backup directory" >> "$LOG_FILE"
    mkdir "${HOME}/.backup"
fi

# Setup links
setup_file_link "${CODE_HOME}/zshrc" "${HOME}/.zshrc"
setup_file_link "${CODE_HOME}/zshenv" "${HOME}/.zshenv"
setup_file_link "${CODE_HOME}/inputrc" "${HOME}/.inputrc"
setup_file_link "${CODE_HOME}/gitconfig" "${HOME}/.gitconfig"
setup_file_link "${CODE_HOME}/gitignore_global" "${HOME}/.gitignore_global"
setup_dir_link "${CODE_HOME}/dotemacs.d" "${HOME}/.emacs.d"
setup_dir_link "${CODE_HOME}/bin" "${HOME}/bin"
setup_dir_link "${CODE_HOME}/config" "${HOME}/.config"

run_script() {
    local script_path=$1
    local script_name=$(basename "$script_path")

    echo "Running $script_name..."
    echo "Running $script_name..." >> "$LOG_FILE"

    if . "$script_path" >> "$LOG_FILE" 2>&1; then
        echo "$script_name executed successfully." >> "$LOG_FILE"
        echo "$script_name executed successfully."
    else
        echo "$script_name failed to execute." >> "$LOG_FILE"
        echo "$script_name failed to execute."
    fi
}

if [ "$(uname)" == "Linux" ]; then
    run_script "${CODE_HOME}/install/dev-tools.sh"
    run_script "${CODE_HOME}/install/python.sh"
    run_script "${CODE_HOME}/install/clang17.sh"
    run_script "${CODE_HOME}/install/clangd.sh"
    run_script "${CODE_HOME}/install/cmake.sh"
    run_script "${CODE_HOME}/install/golang.sh"
    run_script "${CODE_HOME}/install/zsh.sh"
    run_script "${CODE_HOME}/install/ohmyzsh.sh"
    run_script "${CODE_HOME}/install/pure.sh"
    run_script "${CODE_HOME}/install/gtk-3.sh"
    run_script "${CODE_HOME}/install/ranger.sh"
    run_script "${CODE_HOME}/install/nvm.sh"
    run_script "${CODE_HOME}/install/lua.sh"
    run_script "${CODE_HOME}/install/nvim.sh"
fi

echo "Installation completed at $(date)" >> "$LOG_FILE"
