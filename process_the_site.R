
#region_to_report <- "GLO"

# -- delete output/ -folder recursively
unlink(paste0(root.dir.web,"/_process"), recursive = TRUE)
unlink(paste0(root.dir.web,"/regions/"), recursive = TRUE)


# -- Create output folder if not exists --- #
if (!file.exists(paste0(root.dir.web,"/_process"))) dir.create(paste0(root.dir.web,"/_process"))
if (!file.exists(paste0(root.dir.web,"/regions/"))) dir.create(paste0(root.dir.web,"/regions/"))

## Copy .Rnw files into process/-folder
flist <- list.files(paste0(root.dir.web,"/_input/"),
                    "+[.]Rmd$",
                    full.names = TRUE)
file.copy(flist, paste0(root.dir.web,"/_process"), overwrite = TRUE)

# Lets automate some changes in latex classes depending on what type of doc we want
setwd(paste0(root.dir.web,"/_process"))


###################################################################################3
#   _                           _                   _
#  | |     ___    ___   _ __   | |__    ___   __ _ (_) _ __   ___
#  | |    / _ \  / _ \ | '_ \  | '_ \  / _ \ / _` || || '_ \ / __|
#  | |___| (_) || (_) || |_) | | |_) ||  __/| (_| || || | | |\__ \
#  |_____|\___/  \___/ | .__/  |_.__/  \___| \__, ||_||_| |_||___/
#                      |_|                   |___/

## ---- loop_begins ----

for (region_to_report in regionS_to_report) {
  
  source(paste0(root.dir.web,"_code/hooks_and_parameters.R"))
  
  if(region_to_report == "RAP") region_name <- "Asia and the Pacific"
  if(region_to_report == "RAF") region_name <- "Africa"
  if(region_to_report == "REU") region_name <- "Europe and Central Asia"
  if(region_to_report == "RNE") region_name <- "North Africa and the Middle East"
  
  ### Which spreads
  spreads <- read_csv(paste0(root.dir,"/input/define_spreads.csv"))
  # subset to particular regions colunm
  spreads <- spreads[c("SPREAD",region_to_report)]
  
  # lets incorporate both condition the include_partX and spread based on Px found in spread id.
  spreadsP1  <- spreads[grep("P1",  spreads$SPREAD),]
  spreadsP2  <- spreads[grep("P2",  spreads$SPREAD),]
  spreadsP3  <- spreads[grep("P3",  spreads$SPREAD),]
  spreadsP4  <- spreads[grep("P4",  spreads$SPREAD),]
  spreadsP5  <- spreads[grep("P5",  spreads$SPREAD),]
  spreadsP6  <- spreads[grep("P6",  spreads$SPREAD),]
  # spreadsP7  <- spreads[grep("P7",  spreads$SPREAD),]
  # spreadsP8  <- spreads[grep("P8",  spreads$SPREAD),]
  # spreadsP9  <- spreads[grep("P9",  spreads$SPREAD),]
  # spreadsP10 <- spreads[grep("P10", spreads$SPREAD),]
  
  # if part marked not included, them give value 0 for each spread
  
  if (!include_part1) spreadsP1[2]   <- 0
  if (!include_part2) spreadsP2[2]   <- 0
  if (!include_part3) spreadsP3[2]   <- 0
  if (!include_part4) spreadsP4[2]   <- 0
  if (!include_part5) spreadsP5[2]   <- 0
  if (!include_part6) spreadsP6[2]   <- 0
  # if (!include_part7) spreadsP7[2]   <- 0
  # if (!include_part8) spreadsP8[2]   <- 0
  # if (!include_part9) spreadsP9[2]   <- 0
  # if (!include_part10) spreadsP10[2] <- 0
  
  # Create logical objects for each spread to be given for EVAL
  spreads_for_parts <- apropos("spreadsP")
  #
  for (spr in spreads_for_parts){
    
    for (i in 1:nrow(get(spr))) {
      if (get(spr)[[i,2]] == 0) value <- FALSE
      if (get(spr)[[i,2]] == 1) value <- TRUE
      assign(get(spr)[[i,1]],value,envir = globalenv())
    }
    
  }
  

  if (!file.exists(paste0(root.dir.web,"/regions/",region_to_report))) dir.create(paste0(root.dir.web,"/regions/",region_to_report))
  if (!file.exists(paste0(root.dir.web,"/regions/",region_to_report,"/figure"))) dir.create(paste0(root.dir.web,"/regions/",region_to_report,"/figure"))
  
  knitr::knit("main.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/index.md") )
  knitr::knit("part1.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/part1.md") )
  knitr::knit("part2.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/part2.md") )
  knitr::knit("part3.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/part3.md") )
  knitr::knit("part4.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/part4.md") )
  knitr::knit("countryprofiles.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/countryprofiles.md") )
  knitr::knit("definitions.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/definitions.md") )
  knitr::knit("notes.Rmd",output =paste0(root.dir.web,"regions/",region_to_report,"/notes.md") )
  
  
  flist <- list.files(paste0(root.dir.web,"_process/figure"),
                      "+[.]png$",
                      full.names = TRUE)
  file.copy(flist, paste0(root.dir.web,"/regions/",region_to_report,"/figure"), overwrite = TRUE)

}