# Time Series Forecasting in R

A recovered 2024 STAT443 forecasting project by Lyncy Li, covering financial risk, hydrology, missing-value imputation, production forecasting, and pollution forecasting. R code was developed with ChatGPT assistance.

This package contains recovered code for **scenarios 1, 2, and 5**, plus portable adaptations and the original project report. It is not a complete reproduction of the five-scenario submission.

## Recovery status

| Scenario | Report methods | Source-code status |
|---|---|---|
| 1: Water levels | Seasonal ARIMA; 24-month forecasts | Diagnostics and modeling code recovered; original data-loading code absent |
| 2: Forty stocks | GARCH(1,1); 10-step 15% quantiles | Original loop and annotated revision recovered |
| 3: Beer imputation | missForest; comparison with na.approx and na.interp | Code not included in supplied chat excerpt |
| 4: Beer forecasts | Seasonal ARIMA; 24-month forecasts | Code not included in supplied chat excerpt |
| 5: Three-city pollution | Automated seasonal ARIMA; 336 half-hour steps | Original forecasting function and diagnostic revision recovered; original data import absent |

## Files

- `R/`: portable adaptations prepared in October 2026; distinct from original code.
- `archive/`: recovered historical snippets, with original assumptions and limitations.
- `report/stat443-final.pdf`: original report, preserved unchanged.
- `docs/RECOVERY.md`: source locations, changes, and methodological limitations.

## Data and execution

Original datasets are not included. No original forecasts have been reproduced in this recovery environment, which has no R installation. Package versions from 2024 are unknown.

Install the required packages in R:

```r
install.packages(c("forecast", "tseries", "rugarch", "gtools"))
```

Run from the project root:

```sh
Rscript R/scenario1_hydrology.R data/hydrology.txt output/hydrology
Rscript R/scenario2_stocks.R data/stocks output/stock-quantiles.txt
Rscript R/scenario5_pollution.R data/city1.txt data/city2.txt data/city3.txt output/pollution
```

Hydrology input: a header-free numeric sequence of consecutive monthly observations, with no dates or missing values. The adapter uses an observation-index time axis because the original start date is unknown.

Stock inputs: exactly `stock1.txt` through `stock40.txt`, each a header-free, single-column numeric series in chronological order. Confirm that these are the assignment's intended modeling inputs (e.g. returns). The recovered script does **not** convert prices into returns. It writes a 10-by-40 comma-separated matrix, stocks ordered numerically.

The stock forecasts use the historical plug-in calculation `mu + qnorm(0.15) * sigma`. Multi-step GARCH predictive distributions need not be exactly Gaussian; these are model-based quantile approximations, not demonstrated calibrated risk limits.

## Interpretation

The report documents analyses, not a validated production trading model. No competition ranking, held-out forecast error, or successful VaR backtest is available. Seasonal ARIMA selections may differ under new package versions. Data redistribution permission has not been established; raw data are excluded.

Pollution inputs: three header-free numeric sequences, one for each city, in chronological order at uninterrupted half-hour intervals. Filenames in the command are adapter conventions, not recovered original data filenames. The adapter uses frequency 48, selects a model separately for each city, and exports a 336-by-3 forecast matrix. Historical observations followed by future forecasts are not an out-of-sample accuracy test.
