#!/bin/bash
source ../common/menu.sh
source products.sh

title="Install IDEs and configure them?"
menu_args=("$title")

for code in "${product_codes[@]}"; do
	label="Install ${product_names[$code]} (${product_desc[$code]})"
    cmd="./install.sh $code ${product_dir[$code]}"
    menu_args+=("$label" "$cmd")
done

menu "${menu_args[@]}"
