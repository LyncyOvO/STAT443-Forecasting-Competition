# Scenario 5 
###
forecast5 <- matrix(1:(3*336),336,3) # Forecasts for cities 1-3 should be stored in the columns of a 336x3 dimensional matrix
# By setting the frequency correctly, any seasonal effects or daily patterns in the data are accurately modeled and forecasted.
pollution_city1 <- ts(pollutionCity1, frequency = 48) # frequency = 48: Appropriate for half-hourly data because it reflects 
pollution_city2 <- ts(pollutionCity2, frequency = 48) # the number of half-hour intervals in one day.
pollution_city3 <- ts(pollutionCity3, frequency = 48)
# Function to forecast each city's pollution data
forecast_city <- function(city_ts) {
  # Fit ARIMA model
  fit <- auto.arima(city_ts)
  # Forecast the next 336 half-hourly steps
  forecast_city <- forecast(fit, h = 336)
  # Return the forecasted values (mean)
  return(forecast_city$mean)
}
# Forecast pollution for city
forecast_city1 <- forecast_city(pollution_city1)
forecast_city2 <- forecast_city(pollution_city2)
forecast_city3 <- forecast_city(pollution_city3)
# Combine the forecasts into a matrix
forecast5 <- cbind(forecast_city1, forecast_city2, forecast_city3)
print(forecast5)
plot(forecast5)
write.table(forecast5, file = paste("Scenario5_",last.name,student.id,".txt", sep = ""), sep ="," , col.names = F, row.names = F )
