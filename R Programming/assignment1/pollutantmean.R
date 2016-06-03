# Calculate the mean of a pollutant (sulfate or nitrate) across a specified list of monitors
pollutantmean <- function(dir, pollutant, monitors = 1:332) {
        ## 'dir' is a character vector of length 1 indicating the location of the CSV files
        ## 'pollutant' is a character vector of length 1 indicating the name of the pollutant for which we will calculate the mean; either "sulfate" or "nitrate".
        ## 'monitors' is an integer vector indicating the monitor ID numbers to be used
        
        # Check if pollutant is valid
        if (! (pollutant %in% c("sulfate", "nitrate"))) {        stop("invalid pollutant")       }

        all = numeric()
        for (id in monitors) {
                file = sprintf("%s/%03d.csv", dir, id)
                d = read.csv(file)
                all = c(all, d[, pollutant])    # Append readings from monitors
        }
        
        ## Return the mean of the pollutant across all monitors list in the 'monitors' vector (ignoring NA values)
        round(mean(all, na.rm = T), 3)
}