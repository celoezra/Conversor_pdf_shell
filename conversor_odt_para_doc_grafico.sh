#!/bin/bash

trim_path() {
    local path=$1
    # Remove espaços em branco no início e no final do caminho
    path="${path#"${path%%[![:space:]]*}"}"
    path="${path%"${path##*[![:space:]]}"}"
    echo "$path"
}

# Solicita o caminho do arquivo de entrada
input_file=$(zenity --file-selection --title="Selecionar arquivo .odt")

# Verifica se o arquivo de entrada foi selecionado
if [ -z "$input_file" ]; then
    zenity --error --text="Nenhum arquivo de entrada selecionado."
    exit 1
fi

# Verifica se o arquivo de entrada existe
if [ ! -f "$input_file" ]; then
    zenity --error --text="O arquivo '$input_file' não existe."
    exit 1
fi

# Solicita o caminho para salvar o arquivo convertido
output_path=$(zenity --file-selection --directory --title="Selecionar diretório de saída")

# Verifica se o caminho de saída foi selecionado
if [ -z "$output_path" ]; then
    zenity --error --text="Nenhum diretório de saída selecionado."
    exit 1
fi

# Remove espaços em branco no início e no final do caminho
input_file=$(trim_path "$input_file")
output_path=$(trim_path "$output_path")

# Define o nome do arquivo de saída
output_file="${output_path%/}/$(basename "${input_file%.odt}.doc")"

# Converte o arquivo ODT para DOC utilizando o LibreOffice
libreoffice --convert-to doc --outdir "$output_path" "$input_file"

# Verifica se a conversão foi bem-sucedida
if [ $? -eq 0 ]; then
    zenity --info --text="Arquivo convertido com sucesso. O arquivo de saída é: $output_file"
else
    zenity --error --text="Ocorreu um erro durante a conversão do arquivo."
fi
