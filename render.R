library(rmarkdown)
library(quarto)


repeat{

  quarto:::quarto_render("/home/rp1/Documents/canthosxh/test.rmd")

  Sys.sleep(180)

}


system('/home/rp1/Documents/autocommit.sh')
