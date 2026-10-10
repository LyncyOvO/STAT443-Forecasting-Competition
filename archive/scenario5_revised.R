# Load necessary libraries
library(forecast)

# Set the frequency for half-hourly data
pollution_city1 <- ts(pollutionCity1, frequency = 48) 
pollution_city2 <- ts(pollutionCity2, frequency = 48) 
pollution_city3 <- ts(pollutionCity3, frequency = 48)

# Function to forecast each city's pollution data
forecast_city <- function(city_ts) {
  # Fit ARIMA model automatically
  fit <- auto.arima(city_ts)
  
  # Print model summary for diagnostics
  print(summary(fit))
  
  # Plot residuals and ACF for diagnostics
  checkresiduals(fit)
  
  # Forecast the next 336 half-hourly steps
  forecast_city <- forecast(fit, h = 336)
  
  # Return the forecasted values (mean) and optionally, prediction intervals
  return(forecast_city$mean)
}

# Forecast pollution for each city
forecast_city1 <- forecast_city(pollution_city1)
forecast_city2 <- forecast_city(pollution_city2)
forecast_city3 <- forecast_city(pollution_city3)

# Combine the forecasts into a matrix
forecast5 <- cbind(forecast_city1, forecast_city2, forecast_city3)

# Print the forecast matrix
print(forecast5)

# Optionally, plot the forecasts vs. actuals for the first city
plot(pollution_city1, col = "blue", main = "City 1: Actual vs Forecast", ylab = "Pollution Level", xlab = "Time")
lines(forecast_city1, col = "red", lty = 2)
legend("topright", legend = c("Actual", "Forecast"), col = c("blue", "red"), lty = 1:2)

# Save the forecasts to a file
write.table(forecast5, file = paste("Scenario5_", last.name, student.id, ".txt", sep = ""), sep =",", col.names = FALSE, row.names = FALSE)
