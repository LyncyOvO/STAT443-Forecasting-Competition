# Recovered input data

Selected inputs from the author's saved `.RData` workspace, added on 11 October 2026 (Singapore). These are recovered in-memory datasets, not verified byte-for-byte copies of the original course distribution.

| File | Saved object | Rows | Notes |
|---|---|---:|---|
| hydrology.txt | hydrology_data | 576 | Header-free monthly values; no missing values |
| city1.txt | pollutionCity1 | 2,544 | Header-free half-hourly values |
| city2.txt | pollutionCity2 | 2,544 | Header-free half-hourly values |
| city3.txt | pollutionCity3 | 2,544 | Header-free half-hourly values |
| beer/beer.csv | beer | 435 | Date, Value; 30 missing values retained as NA |
| beer/temperature.csv | temperature | 581 | Year, Month, Value |
| beer/car.csv | car | 369 | Date, Value |
| beer/gas.csv | gas | 435 | Date, Value |
| beer/electricity.csv | electricity | 435 | Date, Value |
| stocks-partial/unidentified-stock.txt | stock_data | 150 | Stock number unverified; embedded Value header removed |

The pollution series and auxiliary series have no missing values. Original row order is preserved. CSV files have headers and omit R row names. Floating-point values use 17 significant digits for round-trip preservation. No resampling, imputation, or price-to-return conversion was performed. Auxiliary series have different time ranges; align by dates before using them together.

## Read in R

Run from the repository root:

```r
hydrology_data <- data.frame(Value = scan("data/hydrology.txt", quiet = TRUE))
hydro_ts <- ts(hydrology_data$Value, frequency = 12)
pollutionCity1 <- data.frame(Value = scan("data/city1.txt", quiet = TRUE))
pollutionCity2 <- data.frame(Value = scan("data/city2.txt", quiet = TRUE))
pollutionCity3 <- data.frame(Value = scan("data/city3.txt", quiet = TRUE))
beer <- read.csv("data/beer/beer.csv", na.strings = "NA")
temperature <- read.csv("data/beer/temperature.csv")
car <- read.csv("data/beer/car.csv")
gas <- read.csv("data/beer/gas.csv")
electricity <- read.csv("data/beer/electricity.csv")
```

The hydrology and pollution text files match the existing command-line adapters. Original calendar start dates for those series are not established.

## Incomplete stock recovery

The workspace contains a single `stock_data` object with an embedded header followed by 150 numeric values. Its stock number cannot be reliably determined. It is kept outside `data/stocks/` to avoid presenting it as a verified member of the required stock1–stock40 set.

The saved `forecast2` matrix is only the initialization sequence 1–400, not a completed forecast. It is excluded. The saved `stock_ts` integer codes are also excluded. The 40-stock model cannot be reproduced from this workspace alone.

## Provenance and verification

`manifest.json` records the source-workspace SHA-256, each exported file's SHA-256, source object, dimensions, and missing-value count. Exports were read back and compared against the decoded source values. The original workspace was not committed: it also contains personal identifiers, local paths, unrelated coursework, and model/intermediate objects.

Scenarios 1 and 5 have now been recomputed in R; see [the rerun results](../results/2026-10-11/README.md). Scenario 3–4 source scripts are still missing. The project author supplied these course data; no additional data license is granted.
