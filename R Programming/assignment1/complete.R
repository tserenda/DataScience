# Report the number of completely observed cases in each data file
complete <- function(dir, id = 1:332) {
        ## 'dir' is a character vector of length 1 indicating the location of the CSV files
        ## 'id' is an integer vector indicating the monitor ID numbers to be used
        
        ## Return a data frame of the form where 'id' is the monitor ID number and 'nobs' is the number of complete cases
        ## id nobs
        ## 1  117
        ## 2  1041
        
        # Initialize the data frame to be returned
        obs = data.frame()
        
        for (num in id) {
                file = sprintf("%s/%03d.csv", dir, num)
                data = read.csv(file)
                
                nobs = sum(complete.cases(data))
                obs = rbind(obs, c(num, nobs))
        }
        names(obs) = c("id", "nobs")
        obs
}
