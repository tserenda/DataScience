answers = c("B", "A", "B", "A",
            "A", "E", "D", "B",
            "A", "A", "B", "C",
            "B", "A", "E", "E",
            "A", "B", "B", "B")
pml_write_files = function(x) {
        n = length(x)
        for(i in 1:n) {
                filename = paste0("problem_id_", i, ".txt")
                write.table(x[i], file = filename, quote = FALSE, row.names = FALSE, col.names = FALSE)
        }
}

pml_write_files(answers)
