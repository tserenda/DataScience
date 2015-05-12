setwd("C:/GIT/DS/RP/assignment3")

# Read the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital
# that has the best (i.e. lowest) 30-day mortality for the specified outcome in that state.

best <- function(state, outcome) {

        # Read outcome data
        csv <- "outcome-of-care-measures.csv"
        H <- read.csv(csv, colClasses = "character")
        
        # Check state and outcome
        outcomes <- c("heart attack", "heart failure", "pneumonia")
        if (! state %in% unique(H$State))       stop("invalid state")
        if (! outcome %in% outcomes)            stop("invalid outcome")

        ## Return hospital name in that state with lowest 30-day death rate
        if (outcome == "heart attack")          rate <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
        if (outcome == "heart failure")         rate <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
        if (outcome == "pneumonia")             rate <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
        
        # Narrow down to state hospitals with data
        H <- H[H$State == state & H[, rate] != "Not Available", c("Hospital.Name", rate)]
        H[, rate] <- as.numeric(H[, rate])
        
        # Order by rate and hospital name
        H <- H[order(H[, rate], H$Hospital.Name), ]
        
        # Return the first one
        head(H, 1)$Hospital.Name
}