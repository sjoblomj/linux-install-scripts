#!/bin/zsh

product_codes=()
product_codes+=("IIU")
product_codes+=("GO")
product_codes+=("PCP")
product_codes+=("CL")

declare -A product_names
product_names[IIU]="IntelliJ IDEA"
product_names[GO]="GoLand"
product_names[PCP]="PyCharm"
product_names[CL]="CLion"

declare -A product_desc
product_desc[IIU]="Java and Kotlin"
product_desc[GO]="Go"
product_desc[PCP]="Python"
product_desc[CL]="C and C++"

declare -A product_dir
product_dir[IIU]="idea"
product_dir[GO]="GoLand"
product_dir[PCP]="pycharm"
product_dir[CL]="clion"
