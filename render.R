library(rmarkdown)


repeat{

  rmarkdown:::render("/home/rp1/Documents/canthosxh/test.rmd")

  Sys.sleep(180)

}


system('/home/rp1/Documents/autocommit.sh')
