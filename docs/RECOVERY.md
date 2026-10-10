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

## Verification and remaining work

Extraction boundaries and text transformations were checked. R is unavailable in this environment, so syntax has not been checked by R and no model has been run. Raw datasets, 2024 package versions, and scenario 3–4 scripts are still needed for full reproduction. No new replacement code for the missing scenarios was invented.

## Second excerpt

`Pasted text(1).txt` supplies the original Scenario 5 function and an assistant revision adding summaries and residual diagnostics. These are preserved in `archive/scenario5_original.R` and `archive/scenario5_revised.R`. Both assume `pollutionCity1`, `pollutionCity2`, and `pollutionCity3` have already been loaded. The revised snippet returns only point forecasts, despite its comment mentioning optional intervals.

The portable adapter adds explicit file inputs, finite-value validation, 95% intervals, output directories, and session information. It plots the forecast object so that the horizontal axis includes the future horizon; simply enlarging the PNG or margins in the old snippet does not extend an axis limited to the observed series. It preserves `auto.arima` defaults from the recovered code. Default automatic search may be approximate for long seasonal series; it is not a guarantee of a globally optimal model.

The second excerpt also contains a later GitHub proposal and example hydrology code. Its suggested CSV header `Value`, 576-observation claim, and exhaustive-search options are not treated as verified properties of the original dataset or original submission. Scenario 3–4 code is still absent; mentions in prose and suggested directory trees are not code recovery.

Generic plotting suggestions subtract `actual_city*` and `forecast_city*` without proving that they cover the same times. They were not promoted into an accuracy evaluation. Diagnostics use fitted residuals; no held-out performance is claimed.
