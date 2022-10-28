library(tidyverse)
library(here)

# create a list of files
files <- list.files(
  here("data"), # look in the study-data folder
  full.names = TRUE,  # use the full paths of the files
  pattern = ".csv",   # only read in .csv files
  recursive = TRUE)   # include files within subfolders
# read in the files and combine them together
# map_df takes a function, in this case read_csv().
# show_col_types suppresses output since we're reading in many files
df <- files %>%
  map_dfr(read_csv, show_col_types = FALSE)

# the final data is called summary_df
# created by starting with df
# then group by the variables of interest. 
# I added condition, because it doesn't make a whole lot
# of sense to drop it if you want to keep spt0217 column. 
# Would be good to check and make sure the other columns dropped
# arent important. 
summary_df = df %>% 
  # for each unique combo of these columns
  group_by(participant,phase,session, condition, spt2017) %>%
  # calculate mean accuracy, sum correct, and total trials
  summarize(accuracy=mean(response, na.rm = TRUE),
            sum_correct=sum(response, na.rm = TRUE),
            trials = n()) 
