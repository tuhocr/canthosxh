library(rmarkdown)
library(quarto)


repeat{

  quarto:::quarto_render("/home/rp1/Documents/canthosxh/index.qmd")

  Sys.sleep(9000)

}


# system('/home/rp1/Documents/autocommit.sh')
