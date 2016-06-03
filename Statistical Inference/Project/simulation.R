set.seed(1)
nosim <- 1000
n <- 40
lambda <- .2
sample.mean <- apply(matrix(rexp(nosim * n, lambda), nosim), 1, mean)

# Distribution properties of sample.mean
range.SM <- range(sample.mean)
mean.SM <- mean(sample.mean)
sd.SM <- sd(sample.mean)
variance.SM <- sd.SM ^ 2
median.SM <- qnorm(0.5, mean.SM, sd.SM)

# The graphical methods for checking data normality in R still leave much to your own interpretation. 

# Theoretical properties of exponential distribution
mu = 1 / lambda
sd.E = 1 / lambda
variance.E = sd.E^2

sem <- sd.E/sqrt(n)
# 1. Show where the distribution is centered at and compare it to the theoretical center of the distribution.
# Hypothesis: Sample means is normally distributed

# mean and median of sample dist overlap
if (abs(mean.SM - median.SM) < 0.0005) {
        sprintf("Mean and median are the same")
} else {
        sprintf("Mean and median are NOT the same")
}

# according to LLN, average limites to population mean mu
if (abs(mean.SM - mu) < 0.05) {
        sprintf("sample mean and population mean does converge")
} else {
        sprintf("sample mean and population mean does NOT converge")
}



# Shapiro test
result <- shapiro.test(sample.mean)
sprintf("Shapriro test yields %.5f", result$p.value)
# This p-value tells you what the chances are that the sample comes from a normal distribution.
# The lower this value, the smaller the chance. Statisticians typically use a value of 0.05 as a cutoff,
# so when the p-value is lower than 0.05, you can conclude that the sample deviates from normality.

# QQ Plot test
qqnorm(sample.mean)
qqline(sample.mean)

#If the data is normally distributed, the points in the QQ-normal plot lie on a straight diagonal line. 
# The deviations from the straight line are minimal. This indicates normal distribution.



# 2. Show how variable it is and compare it to the theoretical variance of the distribution.
# Theory says that if X is random variable then its var is expected square distrance from the mean


#variance of sample mean is the populqation variabne divided by n
theory.var <- sd.E / sqrt(40)
if (abs(sd.SM - theory.var) < 0.05) {
        sprintf("theory sample var of expo dist, sample var of simulated means are the same")
} else {
        sprintf("theory sample var of expo dist, sample var of simulated means are NOT the same")
}