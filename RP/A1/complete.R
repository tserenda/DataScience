# Report the number of completely observed cases in each data file
complete <- function(directory, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return a data frame of the form:
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where 'id' is the monitor ID number and 'nobs' is the
    ## number of complete cases
    
    # Initialize the data frame to be returned
    observations <- data.frame()

    for (num in id) {
        # Read in the data for each monitor
        filename <- sprintf("%s/%03d.csv", directory, num)
        monitor <- read.csv(filename)
        
        complete <- sum(complete.cases(monitor))
        observations <- rbind(observations, c(num, complete))
    }
    names(observations) <- c("id", "nobs")
    observations
}