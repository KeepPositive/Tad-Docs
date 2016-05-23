#! /bin/bash

START_DIR=$(pwd)
OUTPUT_TYPE=$1

## Start functions
help_message ()
{
    printf "bash build_documents.sh [FILE_TYPE]\n\n"
    printf "'help'\tPrint this help message\n"
    printf "'html'\tExport documents to HTML files in the html/ directory\n"
    printf "'pdf'\tExport documents to pdf files in the pdf/ directory\n"
}

html_output ()
{
    # Output documents in the HTML5 format
    output_dir="$START_DIR/html"

    mkdir -v "$output_dir"

    for adoc_file in "$START_DIR/"*.adoc
    do
        asciidoctor --destination-dir="$output_dir" "$adoc_file"
    done

    echo "HTML documents output to $output_dir"
}

pdf_output ()
{
    # Output documentation in the PDF format
    output_dir="$START_DIR/pdf"
    mkdir -v "$output_dir"

    for adoc_file in "$START_DIR/"*.adoc
    do
        asciidoctor-pdf --destination-dir="$output_dir" "$adoc_file"
    done

    echo "PDF documents output to $output_dir"
}
## End functions


## Start script
echo "Let's make some documentation!"

case $OUTPUT_TYPE in
"html")
    html_output ()
;;

"pdf")
    pdf_output ()
;;

*)
    help_message ()
;;
esac
## End script
