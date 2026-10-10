# Portable adaptation of recovered chat code; not executed on original data.
# Load necessary libraries
library(rugarch)
library(gtools)  # For mixedsort function

# Set the directory where your stock files are located
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2L) stop("Usage: Rscript R/scenario2_stocks.R DATA_DIRECTORY OUTPUT_FILE")
data_dir <- args[1]
output_file <- args[2]

# List all .txt files that start with "stock" in the directory
file_list <- list.files(data_dir, pattern = "^stock[0-9]+\\.txt$", full.names = TRUE)

# Ensure the files are ordered correctly
sorted_file_list <- mixedsort(file_list)
expected <- paste0("stock", 1:40, ".txt")
if (!identical(basename(sorted_file_list), expected)) stop("Expected exactly stock1.txt through stock40.txt")
print(sorted_file_list)  # Now it should print the files in the correct order

# Initialize the forecast matrix (10 steps ahead for 40 stocks)
forecast2 <- matrix(NA, nrow = 10, ncol = 40)  # Initialize with NA to ensure clarity

# Loop over each stock file to fit the model and generate forecasts
for(i in 1:length(sorted_file_list)) {
  # Load the stock data
  stock_data <- read.table(sorted_file_list[i], header = FALSE)
  
  # Convert the data to a time series object (assumed to be univariate)
  if (ncol(stock_data) != 1L || !is.numeric(stock_data[[1]]) ||
      nrow(stock_data) < 20L || any(!is.finite(stock_data[[1]]))) {
    stop(paste("Expected a finite, single-column numeric series:", sorted_file_list[i]))
  }
  stock_ts <- ts(stock_data[,1])  # Assuming stock data is in the first column
  
  # Specify a GARCH(1,1) model
  garch_spec <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                           variance.model = list(garchOrder = c(1, 1)),
                           distribution.model = "norm")  # Normal distribution assumed
  
  # Fit the GARCH model to the time series data
  garch_fit <- ugarchfit(spec = garch_spec, data = stock_ts)
  if (garch_fit@fit$convergence != 0L) stop(paste("Model failed to converge:", sorted_file_list[i]))
  
  # Forecast 10 steps ahead using the fitted GARCH model
  garch_forecast <- ugarchforecast(garch_fit, n.ahead = 10)
  
  # Extract the forecasted standard deviations (sigma)
  sigma_forecast <- sigma(garch_forecast)
  
  # Calculate the 15% quantile (Value-at-Risk) using the mean and the sigma
  quantile_forecast <- qnorm(0.15, mean = fitted(garch_forecast), sd = sigma_forecast)
  
  # Store the quantile forecast in the corresponding column of the forecast matrix
  if (length(quantile_forecast) != 10L || any(!is.finite(quantile_forecast))) stop("Invalid forecast")
  forecast2[, i] <- as.numeric(quantile_forecast)
}

# Save the forecast matrix to a .txt file
dir.create(dirname(output_file), recursive = TRUE, showWarnings = FALSE)
write.table(forecast2, file = output_file, 
            sep = ",", col.names = FALSE, row.names = FALSE)
