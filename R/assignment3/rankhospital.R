# Read the outcome-of-care-measures.csv file and returns a character vector with the name
# of the hospital that has the ranking specified by the num argument.

rankhospital <- function(state, outcome, num = "best") {
    # Read outcome data
    hospital_data <- "HospitalCompare/outcome-of-care-measures.csv"
    hospitals <- read.csv(hospital_data, colClasses = "character")
    
    # Check state and outcome
    if (is.na(match(state, unique(hospitals$State))))                       stop("invalid state")
    if (! outcome %in% c("heart attack", "heart failure", "pneumonia"))     stop("invalid outcome")

    ## Return hospital name in that state with the given rank 30-day death rate
    if (outcome == "heart attack")          criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
    else if (outcome == "heart failure")    criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
    else                                    criteria <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
    
    # Focus on complete data from hospitals in a specific state.
    state_hospitals <- subset(hospitals, State == state, select = c("Hospital.Name", criteria))
    suppressWarnings(state_hospitals[, criteria] <- as.numeric(state_hospitals[, criteria]))
    state_hospitals <- state_hospitals[complete.cases(state_hospitals), ]
    
    # Order observations based on first, rate criteria, second, hospital name if there is a tie
    state_hospitals <- state_hospitals[order(state_hospitals[, criteria], state_hospitals[, "Hospital.Name"]), , drop = FALSE]
    numofhospitals <- nrow(state_hospitals)
    
    # Return the rank based on num argument
    if (num == "best")              state_hospitals[1, "Hospital.Name"]
    else if (num == "worst")        state_hospitals[numofhospitals, "Hospital.Name"]
    else if (num > numofhospitals)  NA
    else                            state_hospitals[num, "Hospital.Name"]
}