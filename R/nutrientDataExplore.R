### load data
source("R/datsource.R")

# load packages #
ld_pkgs <- c("tidyverse","ggthemes","GGally")
vapply(ld_pkgs, library, logical(1L),
       character.only = TRUE, logical.return = TRUE)
rm(ld_pkgs)

# set themes/global presets
cbPalette <- c("#0072B2","#e79f00","#009E73", "#9ad0f3", "#000000",
               "#D55E00", "#CC79A7", "#F0E442")
ppi <- 300
perms <- 9999 #number of permutations of analyses
theme_set(ggthemes::theme_few())###set theme for all ggplot objects

### copy data if needed
file_name <- "Nuts_Combined_00-19.xlsx"

# Set the source and destination file paths
source_file <- paste0(datfol,file_name)
destination_file <- paste0("data/",file_name)

# Check if the file exists in the data folder
if (!file.exists(destination_file)) {
  # If not, copy the file from the source folder to the data folder
  file.copy(source_file, destination_file)
  cat("File copied successfully.\n")
} else {
  # If the file already exists in the data folder, do nothing
  cat("File already exists in the data folder.\n")
}


df0 <- as_tibble(readxl::read_xlsx(destination_file,
                                   sheet = "All_Nutrients"))

## initial plot ###
png(file = "figs/pairs.png",
    width=12*ppi, height=12*ppi, res=ppi)
df0 %>% 
  select(-c(Region:SAMP_Notes,"TIME OF SAMPLING":"WATER DEPTH IN METRES (IN-SITU)",
            "NGR EASTING","NGR NORTHING",
            "N:P ratio",
            "N_P ratio",
            "N:Si",
            "Phytoplankton",
            "TIME OF HIGH TIDE")) %>% names(.)
ggpairs(.)
dev.off()

## plot N_S ratio
df0$Year <- as.numeric(df0$Year)

df0 %>% 
  filter(!is.na(N_S)) %>% 
  filter(N_S<100) %>% 
  ggplot(., aes(x=SAMP_SAMPLE_DATE, y=N_S, group=WBCode))+
  geom_line(aes(col=WB_Type),alpha=0.2)+geom_point(aes(col=WB_Type))

#consider removing <2008
#annual Si median ~ Total N