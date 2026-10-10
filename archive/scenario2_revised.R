# Load necessary libraries
library(rugarch)
library(gtools)  # For mixedsort function

# Set the directory where your stock files are located
setwd("C:/Users/lincy/Downloads")  # Adjust this path to where your files are located

# List all .txt files that start with "stock" in the directory
file_list <- list.files(pattern = "stock[0-9]+\\.txt")

# Ensure the files are ordered correctly
sorted_file_list <- mixedsort(file_list)
print(sorted_file_list)  # Now it should print the files in the correct order

# Initialize the forecast matrix (10 steps ahead for 40 stocks)
forecast2 <- matrix(NA, nrow = 10, ncol = 40)  # Initialize with NA to ensure clarity

# Loop over each stock file to fit the model and generate forecasts
for(i in 1:length(sorted_file_list)) {
  # Load the stock data
  stock_data <- read.table(sorted_file_list[i], header = FALSE)
  
  # Convert the data to a time series object (assumed to be univariate)
  stock_ts <- ts(stock_data[,1])  # Assuming stock data is in the first column
  
  # Specify a GARCH(1,1) model
  garch_spec <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                           variance.model = list(garchOrder = c(1, 1)),
                           distribution.model = "norm")  # Normal distribution assumed
  
  # Fit the GARCH model to the time series data
  garch_fit <- ugarchfit(spec = garch_spec, data = stock_ts)
  
  # Forecast 10 steps ahead using the fitted GARCH model
  garch_forecast <- ugarchforecast(garch_fit, n.ahead = 10)
  
  # Extract the forecasted standard deviations (sigma)
  sigma_forecast <- sigma(garch_forecast)
  
  # Calculate the 15% quantile (Value-at-Risk) using the mean and the sigma
  quantile_forecast <- qnorm(0.15, mean = fitted(garch_forecast), sd = sigma_forecast)
  
  # Store the quantile forecast in the corresponding column of the forecast matrix
  forecast2[, i] <- quantile_forecast
}

# Save the forecast matrix to a .txt file
write.table(forecast2, file = paste("Scenario2_", last.name, student.id, ".txt", sep = ""), 
            sep = ",", col.names = FALSE, row.names = FALSE)
