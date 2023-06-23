#!/bin/bash

# Exibe uma caixa de diálogo de seleção de arquivo para o PDF de entrada
input_pdf=$(zenity --file-selection --title="Selecione o arquivo PDF de entrada")

# Verifica se um arquivo foi selecionado
if [ -z "$input_pdf" ]; then
  zenity --error --text="Nenhum arquivo PDF selecionado."
  exit 1
fi

# Exibe uma caixa de diálogo de seleção de arquivo para o DOC de saída
output_doc=$(zenity --file-selection --save --confirm-overwrite --file-filter="Documentos Word (*.docx)|*.docx" --title="Salvar como arquivo DOCX")

# Verifica se um arquivo foi selecionado
if [ -z "$output_doc" ]; then
  zenity --error --text="Nenhum arquivo DOCX selecionado."
  exit 1
fi

# Verifica se a extensão .docx está presente no nome do arquivo de saída
if [[ $output_doc != *.docx ]]; then
  output_doc="$output_doc.docx"
fi

# Extrai o texto do PDF usando pdftotext
pdftotext "$input_pdf" temp.txt

# Converte o texto extraído para o formato DOCX usando pandoc
pandoc temp.txt -o "$output_doc"

# Remove o arquivo temporário
rm temp.txt

zenity --info --text="Conversão concluída com sucesso."

