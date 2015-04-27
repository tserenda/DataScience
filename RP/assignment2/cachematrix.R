# makes "special" matrix that is list of functions on x

makeCacheMatrix <- function(x = matrix()) {
    cm <- NULL # cached matrix

    # get & set matrix
    set <- function(y) { x <<- y; cm <- NULL }
    get <- function() x

    # get & set cached matrix
    setInv <- function(inv) { cm <<- inv }
    getInv <- function() cm
    
    list(set = set, get = get, setInv = setInv, getInv = getInv)
}

# return the cached inverse of matrix or 
# calculate the inverse if it hasn't been

cacheSolve <- function(x, ...) {

    inv <- x$getInv()
    if (!is.null(inv)) {
        message("getting cached inverse")
        return(inv)
    }
    
    data <- x$get()
    inv <- solve(data)
    x$setInv(inv)
    inv
}