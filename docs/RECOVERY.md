# Recovery record

## Sources

`Pasted text.txt`, supplied on 10 October 2026, contains 400 lines and begins with “Loading older messages…”. It is a partial chat excerpt, not the entire historical conversation.

- Lines 7–77: Scenario 1 diagnostic/modeling snippet. Prose section headings were converted to R comments in the archived extraction. It assumes `hydro_ts` already exists; its commented data constructor is an example.
- Lines 286–314: Scenario 2 original code posted in the conversation.
- Lines 320–368: Scenario 2 assistant's annotated revision. Both stock versions are preserved separately.
- Lines 119–284: generic assistant backtest/stress-test suggestions, not incorporated into the final stock loop. These are not recovered completed project features.
- No Scenario 3–5 code appears in the first excerpt.

The original report is included unchanged. It reports water-level SARIMA(2,0,0)(1,1,0)[12] and beer-production SARIMA(2,1,2)(0,1,2)[12]. Those reported orders have not been independently refitted here.

## Portable adaptations

Scenario 1 adds explicit numeric input, output paths, 95% intervals, and a session-info file. It retains automatic seasonal ARIMA selection, ACF/PACF, ADF, and residual diagnostics. It uses `checkresiduals` in place of the original unadjusted, fixed-lag Ljung–Box call. The illustrative unconditional differencing step is not treated as a model-selection requirement.

Scenario 2 retains the recovered GARCH specification and 15% quantile calculation. Changes replace the hardcoded Windows directory and surname/student-ID output name with command-line arguments, require exactly 40 correctly numbered files, validate single-column finite inputs, and stop on failed convergence or invalid forecast values. No claim of successful numerical execution is made.

## Excluded faulty suggestions

The historical backtest examples fit on the full return series, do not reserve observations for the requested rolling forecasts, and compare forecasts with an existing tail of the fitting data. They do not establish a valid out-of-sample backtest. The proposed stress example refits a returns model to doubled fitted volatility, which is not a valid implementation of a return-distribution stress scenario. Those assistant suggestions should not be described as successful validation.

Likewise, a nonsignificant Ljung–Box test does not prove residual independence or normality. The original report sometimes overstates these conclusions. It has been kept as a historical artifact, not silently rewritten.

## Initial verification and remaining work (before the R rerun)

Extraction boundaries and text transformations were checked. R is unavailable in this environment, so syntax has not been checked by R and no model has been run. The complete stock dataset, 2024 package versions, and scenario 3–4 scripts are still needed for full reproduction; see the workspace recovery update below. No new replacement code for the missing scenarios was invented.

## Second excerpt

`Pasted text(1).txt` supplies the original Scenario 5 function and an assistant revision adding summaries and residual diagnostics. These are preserved in `archive/scenario5_original.R` and `archive/scenario5_revised.R`. Both assume `pollutionCity1`, `pollutionCity2`, and `pollutionCity3` have already been loaded. The revised snippet returns only point forecasts, despite its comment mentioning optional intervals.

The portable adapter adds explicit file inputs, finite-value validation, 95% intervals, output directories, and session information. It plots the forecast object so that the horizontal axis includes the future horizon; simply enlarging the PNG or margins in the old snippet does not extend an axis limited to the observed series. It preserves `auto.arima` defaults from the recovered code. Default automatic search may be approximate for long seasonal series; it is not a guarantee of a globally optimal model.

The second excerpt also contains a later GitHub proposal and example hydrology code. Its suggested CSV header `Value`, 576-observation claim, and exhaustive-search options are not treated as verified properties of the original dataset or original submission. Scenario 3–4 code is still absent; mentions in prose and suggested directory trees are not code recovery.

Generic plotting suggestions subtract `actual_city*` and `forecast_city*` without proving that they cover the same times. They were not promoted into an accuracy evaluation. Diagnostics use fitted residuals; no held-out performance is claimed.

## Workspace data recovery — 11 October 2026 (Singapore)

The author supplied a saved `.RData` workspace. Selected project input objects were decoded and exported into `data/`; the full workspace was not committed because it also contains personal identifiers, local paths, unrelated coursework, fitted models, and intermediate state. See `data/README.md` and `data/manifest.json` for object names, shapes, missingness, and checksums.

The saved `hydrology_data` object now independently confirms 576 observations. Three `pollutionCity*` objects each contain 2,544 observations. Beer has 435 rows and 30 missing values; its auxiliary series preserve their original dates and lengths. No imputation or alignment was applied during export.

`stock_data` contains one embedded `Value` header followed by 150 numeric observations. Only that header was removed, and the result is explicitly labeled unidentified: the saved loop index and filenames do not establish a reliable stock number. `stock_ts` contains integer codes and is not substituted for the numeric input. `forecast2` is exactly the initialization sequence 1–400 in a 10-by-40 matrix, not completed forecasts; it was excluded. Saved forecast and imputation objects were not promoted into raw inputs.

All exported numeric values were checked by reading the output back and comparing element by element; dates, dimensions, and missingness were also verified. Model execution was subsequently completed for scenarios 1 and 5; see the R rerun below.

## R rerun — 11 October 2026 (Singapore)

Scenarios 1 and 5 were executed successfully from source commit `719f06d0e3c660d9d4059152af68177668468ebc` without changing model code or inputs. R 4.3.3 and the required Ubuntu R packages were downloaded into an isolated local runtime; forecast 8.21.1 and tseries 0.10-55 were used. Full session information, console logs, numeric outputs, and diagnostic PDFs are committed under `results/2026-10-11/`.

The 24 water-level forecasts and 336-by-3 pollution forecasts passed finite-value, dimension, step-order, interval-order, and cross-file consistency checks. Input checksums matched the recovered-data manifest. All four diagnostic PDFs were rendered and visually inspected. `R/validate_results.R` reproduces output-integrity checks without fitting models again.

The water model matches the report's SARIMA(2,0,0)(1,1,0)[12] order. All four residual Ljung-Box tests have p-values below 0.05, so the rerun does not support claiming residual white noise. Pollution intervals frequently extend below zero; these unbounded Gaussian-model intervals were preserved unchanged. City 1 contains three zero observations, making its reported percentage-error metrics infinite. No held-out data or original submitted forecast files were available for an accuracy or exact historical-output comparison. Full details and selected models are in the results README.

Scenario 2 remains blocked by incomplete stock inputs. Scenarios 3 and 4 have recovered data but no recovered executable source scripts; no replacement models were invented for this rerun.
