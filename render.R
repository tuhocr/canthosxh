library(rmarkdown)
library(quarto)


repeat{
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/M1_OUTPUT_TABLE_SXH.qmd"))

  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/index.qmd"))

  Sys.sleep(9000)

}


# system('/home/rp1/Documents/autocommit.sh')

