setwd("C:/GIT/DS/RP/assignment3")

# Return a 2-column data frame containing the hospital in each state that has the ranking specified in num.

rankall <- function(outcome, num = "best") {
        
        # Read outcome data
        csv <- "outcome-of-care-measures.csv"
        H <- read.csv(csv, colClasses = "character")
        
        # Check outcome
        outcomes <- c("heart attack", "heart failure", "pneumonia")
        if (! outcome %in% outcomes) { stop("invalid outcome") }
        
        # Return hospital name in that state with lowest 30-day death rate
        if (outcome == "heart attack")          rate <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
        if (outcome == "heart failure")         rate <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
        if (outcome == "pneumonia")             rate <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
        
        # Narrow down to hospitals with data only
        H <- H[H[, rate] != "Not Available", c("Hospital.Name", "State", rate)]
        H[, rate] <- as.numeric(H[, rate])
        
        # Order hospitals within each state
        unordered <- split(H, H$State)
        ordered <- lapply(unordered, function(x) { x[order(x[, 3], x$Hospital.Name), ] })
        
        # Pick a qualifying hospital from each state
        picked <- sapply(ordered, function(x) {
                if (num == "best")              head(x, 1)$Hospital.Name
                else if (num == "worst")        tail(x, 1)$Hospital.Name
                else if (num < nrow(x))         x[num, "Hospital.Name"]
                else                            NA
        })
        
        # Combine the picked hospitals
        data.frame(hospital = picked, state = names(picked))
}