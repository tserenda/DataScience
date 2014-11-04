# Read the outcome-of-care-measures.csv file and returns a character vector with the name of the hospital
# that has the best (i.e. lowest) 30-day mortality for the specified outcome in that state.

best <- function(state, outcome) {
    # Read outcome data
    hospital_data <- "HospitalCompare/outcome-of-care-measures.csv"
    hospitals <- read.csv(hospital_data, colClasses = "character")
    
    # Check state and outcome
    if (is.na(match(state, unique(hospitals$State))))                       stop("invalid state")
    if (! outcome %in% c("heart attack", "heart failure", "pneumonia"))     stop("invalid outcome")
    
    ## Return hospital name in that state with lowest 30-day death rate
    if (outcome == "heart attack")          criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
    else if (outcome == "heart failure")    criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
    else                                    criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
    
    # Focus on complete data from hospitals in a specific state.
    state_hospitals <- subset(hospitals, State == state, select = c("Hospital.Name", criteria))
    suppressWarnings(state_hospitals[, criteria] <- as.numeric(state_hospitals[, criteria]))
    state_hospitals <- state_hospitals[complete.cases(state_hospitals), ]
    
    # Initialize the best hospital to be the first on the list
    best <- 1L
    rate <- state_hospitals[best, criteria]
    name <- state_hospitals[best, "Hospital.Name"]
    
    for (i in 2:nrow(state_hospitals)) {
        r <- state_hospitals[i, criteria]
        n <- state_hospitals[i, "Hospital.Name"]
        # The lower rate, the better. In case of a tie, a hospital name breaks it.
        if ((r < rate) | (r == rate & n < name)) {
            best <- i
            rate <- r
            name <- n
        }
    }
    name
}