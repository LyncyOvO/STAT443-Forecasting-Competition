# Load necessary libraries
library(forecast)
library(tseries)

# Assuming you have already loaded your hydrological data
# Let's assume the data is stored in a time series object called `hydro_ts`

# Example: Creating a time series object (replace with your actual data)
# hydro_ts <- ts(your_data, start = c(1950, 1), frequency = 12)
# 2. ACF/PACF Plots (Pre-modeling)
# Plot the ACF and PACF of the original time series
par(mfrow = c(2, 1))  # Set up the plot area for two plots

# ACF plot
acf(hydro_ts, main="ACF of Hydrological Data")

# PACF plot
pacf(hydro_ts, main="PACF of Hydrological Data")
# 3. Stationarity Check
# Perform the Augmented Dickey-Fuller Test to check for stationarity
adf_test <- adf.test(hydro_ts)

# Print the results
print(adf_test)

# If the p-value is greater than 0.05, the series is non-stationary, and you might need to difference it
# Differencing the data (if needed)
differenced_hydro_ts <- diff(hydro_ts)

# Plot the differenced series
plot(differenced_hydro_ts, main="Differenced Hydrological Data", ylab="Differenced Values", xlab="Time")

# Re-run ACF and PACF on the differenced series to confirm stationarity
par(mfrow = c(2, 1))
acf(differenced_hydro_ts, main="ACF of Differenced Hydrological Data")
pacf(differenced_hydro_ts, main="PACF of Differenced Hydrological Data")
# 4. Fitting the ARIMA/SARIMA Model
# Fit an ARIMA or SARIMA model to the original or differenced series
# Automatically choose the best model using auto.arima (adjust parameters as necessary)
fit <- auto.arima(hydro_ts, seasonal = TRUE)  # seasonal = FALSE if non-seasonal

# Print the model summary
summary(fit)
# 5. Residual Analysis
# Check the residuals of the fitted model
par(mfrow = c(2, 1))
acf(residuals(fit), main="ACF of Residuals")
pacf(residuals(fit), main="PACF of Residuals")

# Plot the residuals over time
plot(residuals(fit), main="Residuals of the Fitted Model", ylab="Residuals", xlab="Time")
abline(h=0, col="red")

# Perform the Ljung-Box test to check for autocorrelation in the residuals
ljung_box_test <- Box.test(residuals(fit), lag = 20, type = "Ljung-Box")

# Print the results
print(ljung_box_test)

# Check for normality of residuals using a Q-Q plot
qqnorm(residuals(fit))
qqline(residuals(fit), col="red")
# 6. Forecasting and Plotting with 95% Prediction Intervals
# Forecast the next 24 periods (adjust as needed)
forecast_hydro <- forecast(fit, h = 24)

# Plot the forecast with 95% prediction intervals
plot(forecast_hydro, main="Hydrological Forecast with 95% Prediction Intervals", ylab="Water Level", xlab="Time")

# Optional: Print the forecasted values
print(forecast_hydro)
