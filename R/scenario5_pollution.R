# Portable adaptation of recovered Scenario 5 code; recovered inputs are in data/city1.txt through data/city3.txt.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 4L) {
  stop("Usage: Rscript R/scenario5_pollution.R CITY1_FILE CITY2_FILE CITY3_FILE OUTPUT_DIRECTORY")
}
library(forecast)
out_dir <- args[4]
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
forecast5 <- matrix(NA_real_, nrow = 336, ncol = 3)
for (i in seq_len(3)) {
  x <- scan(args[i], quiet = TRUE)
  if (length(x) < 96L || any(!is.finite(x))) {
    stop(paste("Expected at least 96 finite half-hourly observations:", args[i]))
  }
  city_ts <- ts(x, frequency = 48)
  fit <- auto.arima(city_ts)
  capture.output(summary(fit), file = file.path(out_dir, paste0("city", i, "-model.txt")))
  fc <- forecast(fit, h = 336, level = 95)
  if (length(fc$mean) != 336L || any(!is.finite(fc$mean))) stop("Invalid forecast")
  forecast5[, i] <- as.numeric(fc$mean)
  pdf(file.path(out_dir, paste0("city", i, "-diagnostics.pdf")), width = 10, height = 7)
  checkresiduals(fit)
  plot(fc, main = paste("City", i, "history and 336-step forecast"),
       xlab = "Time (48 observations per unit)", ylab = "Pollution level")
  dev.off()
  write.csv(data.frame(step = seq_len(336), mean = as.numeric(fc$mean),
                       lower95 = as.numeric(fc$lower[, 1]), upper95 = as.numeric(fc$upper[, 1])),
            file.path(out_dir, paste0("city", i, "-intervals.csv")), row.names = FALSE)
}
write.table(forecast5, file.path(out_dir, "forecast.txt"), sep = ",",
            row.names = FALSE, col.names = FALSE)
capture.output(sessionInfo(), file = file.path(out_dir, "session-info.txt"))
