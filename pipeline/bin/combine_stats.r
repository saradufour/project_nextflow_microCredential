#!/usr/bin/env Rscript

# Load libraries
#suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(readr)
  library(stringr)
#})

# Get command line arguments (excluding script name)
args <- commandArgs(trailingOnly = TRUE)

# If no files provided, stop with an error
if (length(args) == 0) {
  stop("Usage: script.R file1.tsv file2.tsv ...")
}

file_list <- args

# Process each file and combine results
all_data <- lapply(file_list, function(file) {
  sample_id <- basename(file) %>% str_replace("-report\\.stats\\.tsv$", "")
  df <- read_tsv(file, show_col_types = FALSE) %>%
    mutate(SAMPLEID = sample_id)
  return(df)
}) %>% bind_rows()

write_csv(all_data, "combine_stats.csv")

# Plot
plot <- ggplot(all_data, aes(x = SAMPLEID, y = Proteins.Identified)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Proteins Identified by Sample",
       x = "Sample ID",
       y = "Proteins Identified") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Show plot (if interactive) or save as PDF
if (interactive()) {
  print(plot)
} else {
  ggsave("combine_stats.png", plot, width = 8, height = 5)
}
