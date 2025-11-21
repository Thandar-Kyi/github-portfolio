# **📈Electricity Demand Forecasting — North Island, Auckland**



Hourly load modelling using regression, exponential smoothing, and time-series methods (MATH803 Project Part B).



## **🔍Overview**



This project models and forecasts hourly electricity demand (MW) for Auckland’s North Island region using real-world operational data. The objective is to understand consumption behaviour, identify intraday and weekly seasonal patterns, and generate short-term forecasts using statistical models built in SAS.

The work includes data cleaning, exploratory analysis, regression modelling, seasonal exponential smoothing, and diagnostic evaluation.



## **📂Project Structure**



electricity-forecasting/

│

├── data/           # raw data

├── scripts/        # SAS code: data import, cleaning, regression, ESM

├── figures/        # time-series plots, forecasts, diagnostic charts

├── report/         # full project PDF (MATH803\_Project\_PartB\_ID24251155)

└── README.md       # project summary (this file)





## **📊Dataset**



Source dataset: NorthIslandHourlyElec2-1.xlsx

Imported using SAS PROC IMPORT.



Key fields include:



* DateTime (converted from string to SAS datetime)
* MW — hourly electricity demand
* Temperature (°C)
* WindSpeed (knots)
* Hour extracted using hour(DateTime)



Main characteristics observed:



* Strong daily seasonality: 24-hour demand cycles with night-time lows and evening peaks.
* Mild weekly patterns: visible differences between weekday and weekend demand.
* Non-stationary behaviour: underlying changing levels caused by temperature and external factors.



## **🧠Methods**



**1. Data Cleaning \& Preparation**



* Converted string timestamps into SAS datetime formats
* Extracted date, hour and aligned the time series
* Checked for missing MW values (none found)
* Sorted the series for visualisation and modelling



**2. Exploratory Analysis**



* Time-series plot using PROC SGPLOT
* Identified seasonal, cyclical, and trend components



**3. Regression Model with Intraday Seasonality**



A multiple regression model was fitted:



MW\_t= β\_0+ β\_1  .〖Temperature〗\_t+ β\_2  .〖Windspeed〗\_t+ ∑\_(h=1)^23▒β\_h   .〖Hour〗\_t+ ε\_t



* Hour was treated as a categorical variable → captured 24-hour cycles via dummy variables
* Temperature = significant predictor (p < 0.0001)
* WindSpeed = not significant (p = 0.6295)
* Model fit: Adjusted R² = 0.6908
* 7-day ahead forecast generated using PROC PLM with assumed average weather inputs (Temp = 15°C, WindSpeed = 5 knots)



**4. Exponential Smoothing (Holt-Winters Additive)**



Implemented using PROC ESM:



* Additive seasonal Holt-Winters model
* 24-hour seasonal period
* Forecast horizon = 168 hours (7 days)
* Output includes model coefficients, forecasts, and diagnostic plots
* Seasonal pattern captured strongly by additive components



**5. Diagnostic Checks**



Regression diagnostics included:



* Residual vs predicted → slight heteroscedasticity
* Q-Q plot → approximate normality with tail deviations
* Influence plots → no extreme outliers
* Histogram → reasonable distribution
* Model significance: F = 198.27, p < 0.0001



## **📈Results**



**Regression Forecast Performance**



* Hour-of-day dummy variables captured daily cycles accurately
* Temperature had a strong positive relationship with demand
* Forecast plot showed smooth, realistic 24-hour repeating cycles
* Best for short-term intraday structure



**Holt-Winters (ESM) Forecast Performance**



* Strong performance due to explicit seasonal pattern
* More flexible for changing seasonal dynamics
* Useful for operational short-term load forecasting



**Key Insight**



Intraday seasonality is the dominant driver of electricity demand.

Models that incorporate hour-level seasonal structure (dummy regression or Holt-Winters) outperform simpler trend-based models.



## **🛠Tools**



* **SAS**: PROC IMPORT, DATA STEP, PROC GLM, PROC PLM, PROC TIMESERIES, PROC ESM, PROC SGPLOT
* **Excel**: data pre-processing
* **GitHub**: project documentation \& version control



## **💡What I Learned**



* How to process and model high-frequency time-series data
* Applying categorical regression for intraday seasonality
* Using Holt-Winters exponential smoothing for operational forecasting
* Performing full diagnostic workflow (residuals, influence, QQ plot)
* Building structured SAS pipelines for forecasting tasks



## **🚀Future Improvements**



* Add weather-driven ARIMAX model (temperature as exogenous regressor)
* Compare to machine learning models (Random Forest, XGBoost)
* Rolling-origin cross-validation instead of single-holdout
* Automatic detection of anomalies or holiday effects



## **📘 Academic Integrity Notice**



This project is original work developed by Thandar Kyi as part of coursework and research at Auckland University of Technology (AUT).
It is available publicly for professional portfolio purposes only.
Reuse, copying, or redistribution without attribution is not permitted.
