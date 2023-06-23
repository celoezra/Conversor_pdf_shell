#!/bin/bash

# Exibe uma caixa de diálogo de seleção de arquivo para o arquivo de entrada
input_file=$(zenity --file-selection --title="Selecione o arquivo de entrada")

# Verifica se um arquivo foi selecionado
if [ -z "$input_file" ]; then
  zenity --error --text="Nenhum arquivo selecionado."
  exit 1
fi

# Exibe uma caixa de diálogo de seleção de arquivo para o arquivo de saída PDF
output_pdf=$(zenity --file-selection --save --confirm-overwrite --file-filter="Arquivos PDF (*.pdf)|*.pdf" --title="Salvar como arquivo PDF")

# Verifica se um arquivo foi selecionado
if [ -z "$output_pdf" ]; then
  zenity --error --text="Nenhum arquivo PDF selecionado."
  exit 1
fi

# Verifica a extensão do arquivo de entrada e converte para PDF usando o libreoffice
case "${input_file##*.}" in
  odt)
    libreoffice --convert-to pdf "$input_file" --outdir "$(dirname "$output_pdf")"
    ;;
  doc|docx)
    libreoffice --headless --convert-to pdf --outdir "$(dirname "$output_pdf")" "$input_file"
    ;;
  *)
    zenity --error --text="Formato de arquivo não suportado."
    exit 1
    ;;
esac

zenity --info --text="Conversão concluída com sucesso."

