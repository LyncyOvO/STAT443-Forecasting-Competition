# R rerun: 11 October 2026 (Singapore)

Scenarios 1 and 5 completed successfully using the recovered input files and the existing R adapters at source commit `719f06d0e3c660d9d4059152af68177668468ebc`. Model code and data were not changed for this rerun.

## Results

| Series | Input observations | Forecast steps | Selected model | Residual Ljung-Box p-value |
|---|---:|---:|---|---:|
| Water levels | 576 | 24 monthly steps | ARIMA(2,0,0)(1,1,0)[12] | 1.089e-13 (lag 24, df 21) |
| City 1 | 2,544 | 336 half-hourly steps | ARIMA(3,0,1)(0,0,2)[48], non-zero mean | <2.2e-16 (lag 96, df 90) |
| City 2 | 2,544 | 336 half-hourly steps | ARIMA(3,1,3)(0,0,2)[48] | 0.03539 (lag 96, df 88) |
| City 3 | 2,544 | 336 half-hourly steps | ARIMA(1,1,1)(0,0,2)[48], drift | <2.2e-16 (lag 96, df 92) |

The water-level model order agrees with the historical report. This does not establish that all numerical forecasts equal the original 2024 submission.

## Files

- `hydrology/forecast.txt`: 24 point forecasts, one per line.
- `hydrology/intervals.csv`: step, mean, lower95, upper95.
- `hydrology/diagnostics.pdf`: ACF/PACF, residual diagnostics, Q-Q plot, and forecast plot.
- `hydrology/run.log`: model summary and statistical tests.
- `pollution/forecast.txt`: 336 rows by 3 comma-separated city columns (City 1, 2, 3).
- `pollution/cityN-intervals.csv`, `cityN-model.txt`, `cityN-diagnostics.pdf`: city-specific intervals, fitted model summaries, and plots.
- Each model directory contains `session-info.txt`; `pollution/run.log` records residual tests in city order.
- `validation.txt`: output-integrity checks; `manifest.json`: source commit and SHA-256 checksums.

## Reproduce

Use R with `forecast` and `tseries` installed, then run from the repository root. The execution environment used R 4.3.3, forecast 8.21.1, and tseries 0.10-55; all transitive versions appear in the session files.

```sh
mkdir -p output/rerun/hydrology output/rerun/pollution
Rscript --vanilla R/scenario1_hydrology.R data/hydrology.txt output/rerun/hydrology > output/rerun/hydrology/run.log 2>&1
Rscript --vanilla R/scenario5_pollution.R data/city1.txt data/city2.txt data/city3.txt output/rerun/pollution > output/rerun/pollution/run.log 2>&1
Rscript --vanilla R/validate_results.R output/rerun
```

The isolated runtime invoked the same scripts through `R --vanilla --slave -f SCRIPT --args ...`, equivalent to the Rscript calls above. Automatic seasonal model selection used the adapters' existing defaults.

## Verification and limits

- All 10 recovered input files matched `data/manifest.json`.
- Both R scripts exited successfully. All forecast means and interval endpoints are finite.
- Forecast dimensions, sequential step indices, lower <= mean <= upper, and agreement between point-forecast files and interval-table means passed validation.
- All four PDFs were rendered and visually inspected.
- All four Ljung-Box p-values are below 0.05. Residual serial correlation remains, so these models should not be described as fully adequate or validated production forecasts.
- Unbounded 95% model intervals have negative lower endpoints for 320 City 1 steps, 332 City 2 steps, and 331 City 3 steps. They were preserved rather than clipped. For nonnegative pollution, this is a limitation of the fitted Gaussian models.
- City 1 has three zero-valued inputs: its in-sample MAPE is infinite and is not a usable accuracy summary. The fitted-model summaries retain the original R output.
- Printed training-set errors are in-sample measures. No held-out forecast accuracy, calibrated interval coverage, or exact match to original submitted forecasts was established.
- Scenario 2 cannot run without the complete stock1-stock40 inputs. Scenarios 3 and 4 still lack recovered executable scripts.
