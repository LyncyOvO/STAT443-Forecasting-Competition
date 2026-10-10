forecast2 <- matrix(1:400,10,40) # Forecasts for stock 1-40 should be stored in the columns of a 10x40 dimensional matrix
# Set the directory where your stock files are located
setwd("C:/Users/lincy/Downloads")  # Adjust this path to where my files are
# List all .txt files that start with "stock" in the directory
file_list <- list.files(pattern = "stock[0-9]+\\.txt")
sorted_file_list <- mixedsort(file_list) # Files are disordered and we utilize mixedsort function
print(sorted_file_list) # now it comes with right order
# Loop over each stock file to fit the model and generate forecasts
for(i in 1:length(file_list)) {
  # Load the stock data
  stock_data <- read.table(sorted_file_list[i], header = FALSE)
  # Convert to time series object
  stock_ts <- ts(stock_data)
  # Specify GARCH(1,1) model
  garch_spec <- ugarchspec(mean.model = list(armaOrder = c(0,0)),
                           variance.model = list(garchOrder = c(1, 1)),
                           distribution.model = "norm")
  # Fit the GARCH model
  garch_fit <- ugarchfit(spec = garch_spec, data = stock_ts)
  # Forecast 10 steps ahead
  garch_forecast <- ugarchforecast(garch_fit, n.ahead = 10)
  # Extract the sigma (standard deviation) for the forecasts
  sigma_forecast <- sigma(garch_forecast)
  # Calculate the 15% quantile (VaR) using the mean and the sigma
  quantile_forecast <- qnorm(0.15, mean = fitted(garch_forecast), sd = sigma_forecast)
  # Store the quantile forecast in the corresponding column
  forecast2[, i] <- quantile_forecast
}
write.table(forecast2, file = paste("Scenario2_",last.name,student.id,".txt", sep = ""), sep ="," , col.names = F, row.names = F )
