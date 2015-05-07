# Take a directory of data files and a threshold for complete cases and calculates the correlation between sulfate
# and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than
# the threshold. The function should return a vector of correlations for the monitors that meet the threshold requirement.
# If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0.

corr <- function(dir, threshold = 0) {    
        ## 'dir' is a character vector of length 1 indicating the location of the CSV files
        ## 'threshold' is a numeric vector of length 1 indicating the number of completely observed observations
        ## (on all variables) required to compute the correlation between nitrate and sulfate; the default is 0
        
        # complete() is defined in complete.R and reports the number of completely observed cases in each data file
        coc <- complete(dir)
        
        # monitors that met the threshold requirement
        mtr = coc[coc$nobs > threshold, ]
        
        corr = numeric()
        for (num in mtr$id) {
                filename = sprintf("%s/%03d.csv", dir, num)
                df = read.csv(filename)
                
                corr = c(corr, cor(df$sulfate, df$nitrate, use = "pairwise.complete.obs"))
        }
        corr
}