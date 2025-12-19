library(rmarkdown)
library(quarto)


repeat{
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/M1_OUTPUT_TABLE_SXH.qmd"))
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/M2_OUTPUT_TABLE_ODICH_SXH.qmd"))
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/M3_OUTPUT_TABLE_TCM.qmd"))
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/M4_OUTPUT_TABLE_ODICH_TCM.qmd"))
  
  
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/BAOCAO_SXH.qmd"))
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/BAOCAO_ODICH_SXH.qmd"))
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/BAOCAO_TCM.qmd"))
  
  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/BAOCAO_ODICH_TCM.qmd"))
  

  try(quarto:::quarto_render("/home/rp1/Documents/canthosxh/index.qmd"))
  

  Sys.sleep(3000)

}


# system('/home/rp1/Documents/autocommit.sh')

