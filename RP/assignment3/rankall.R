# Return a 2-column data frame containing the hospital in each state that has the ranking specified in num.

rankall <- function(outcome, num = "best") {
    # Read outcome data
    hospital_data <- "HospitalCompare/outcome-of-care-measures.csv"
    hospitals <- read.csv(hospital_data, colClasses = "character")
    
    # Check outcome
    if (! outcome %in% c("heart attack", "heart failure", "pneumonia")) { stop("invalid outcome") }
    
    ## For each state, find the hospital of the given rank for the outcome.
    ## Return a data frame with the hospital names and the state name
        
    if (outcome == "heart attack")          criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
    else if (outcome == "heart failure")    criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
    else                                    criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"

    # Prepare the data frame
    hospitals <- hospitals[, c("Hospital.Name", "State", criteria)]
    suppressWarnings(hospitals[, criteria] <- as.numeric(hospitals[, criteria]))
    hospitals$State <- as.factor(hospitals$State)
    hospitals <- hospitals[complete.cases(hospitals), ]
    
    # Take a data frame and return the row specified by the 'num' argument
    hospital_rank <- function(df) {
        idx <- 0

        # Order data frame based on - first, rate criteria and second, hospital name
        df <- df[order(df[, criteria], df[, "Hospital.Name"]), , drop = FALSE]
        numofhospitals <- nrow(df)
        
        # Return the rank based on num argument
        if (num == "best")                              { df[1, "Hospital.Name"] }
        else if (num == "worst")                        { df[numofhospitals, "Hospital.Name"] }
        else if (num >=1 & num <= numofhospitals)       { df[num, "Hospital.Name"] }
        else                                            { "<NA>" }
    }
    
    # Group by states and then apply a custom function
    groups <- split(hospitals, hospitals$State)
    result <- lapply(groups, hospital_rank)
    states <- names(result)
    clinics <- unlist(result, use.names = FALSE)
    data.frame(hospital = clinics, state = states)
}