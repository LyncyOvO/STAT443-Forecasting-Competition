# Validate saved outputs without refitting the forecasting models.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L) stop("Usage: Rscript R/validate_results.R RESULTS_DIRECTORY")
root <- args[1]
check_intervals <- function(path, expected_steps, point_forecasts) {
  x <- read.csv(path)
  stopifnot(identical(names(x), c("step", "mean", "lower95", "upper95")),
            nrow(x) == expected_steps,
            identical(x$step, seq_len(expected_steps)),
            all(is.finite(as.matrix(x))),
            all(x$lower95 <= x$mean), all(x$mean <= x$upper95),
            isTRUE(all.equal(x$mean, point_forecasts, tolerance = 1e-10)))
}
hydrology <- scan(file.path(root, "hydrology", "forecast.txt"), quiet = TRUE)
stopifnot(length(hydrology) == 24L, all(is.finite(hydrology)))
check_intervals(file.path(root, "hydrology", "intervals.csv"), 24L, hydrology)
cat("PASS: hydrology has 24 finite forecasts and consistent 95% intervals.\n")
pollution <- as.matrix(read.table(file.path(root, "pollution", "forecast.txt"), sep = ","))
stopifnot(identical(dim(pollution), c(336L, 3L)), all(is.finite(pollution)))
for (i in seq_len(3)) {
  check_intervals(file.path(root, "pollution", paste0("city", i, "-intervals.csv")),
                  336L, pollution[, i])
}
cat("PASS: pollution has 336 x 3 finite forecasts and consistent 95% intervals.\n")
cat("These checks validate output integrity, not out-of-sample forecast accuracy.\n")
