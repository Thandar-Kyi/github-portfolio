📈Auckland Housing Price Index Forecasting

Predictive Modelling of Auckland Housing Prices using ARIMA & ARIMAX

This project investigates the forecasting performance of time-series models for Auckland’s Housing Price Index (HPI). It was completed as part of my STEM Research Project (AUT), with the goal of evaluating whether incorporating economic drivers improves predictive accuracy compared to univariate ARIMA and ETS baselines.

The project includes:
✔ Exploratory analysis of Auckland HPI
✔ ARIMA modelling using Box–Jenkins workflow
✔ ARIMAX using macroeconomic predictors (mortgage rates, migration, building consents)
✔ Rolling-origin evaluation at 1, 3, 6, 12-month horizons
✔ MAE/RMSE/MAPE & Diebold–Mariano (DM) comparisons
✔ Full research report + Python implementation (.ipynb)

🔍1. Project Overview

Auckland’s housing market is highly cyclical and influenced by economic, demographic, and policy factors. The primary research question:

Do ARIMAX models with exogenous economic drivers outperform ARIMA and ETS baselines in forecasting Auckland HPI?

This project identifies the most accurate model across short-term and long-term forecast horizons and evaluates model performance through rigorous out-of-sample testing.

📂2. Project Structure

auckland-house-price-index-forcasting/
│
├── data/                     # HPI + macroeconomic drivers (Processed/output CSVs from Python notebook)
├── scripts/                  # Notebook(s) and Python forecasting code
│   └── STEM_Research_Project_R2.ipynb
├── report/
│   └── STEM_Research_Report_Auckland_HPI.pdf
├── figures/                  # Plots generated from the notebook
└── README.md                 # Project summary (this file)

📊3. Dataset

The project uses monthly time-series data from official New Zealand sources:

3.1 Target Variable

Auckland Housing Price Index (HPI)

⦁	Source: Real Estate Institute of New Zealand (REINZ)
⦁	Monthly index measuring housing price changes
⦁	Inflation-adjusted and seasonally influenced

3.2 Exogenous Variables (ARIMAX Drivers)

1. Mortgage Interest Rate

⦁	Source: Reserve Bank of New Zealand (Series B20)
⦁	Represents borrowing costs impacting demand

2. Net Migration (Auckland Region)

⦁	Source: Stats NZ
⦁	Key demand-side housing driver

3. Residential Building Consents – Auckland

⦁	Source: Stats NZ
⦁	Supply-side indicator affecting medium-term price movement

4. (Optional) Additional Variables Used in Trial Models

⦁	Filled jobs (Auckland)
⦁	Property listings (Real Estate NZ)
⦁	Policy events (AUP 2016, LVR changes, COVID-19)

🧪4. Methods & Models

4.1 Baseline Models

⦁	Seasonal-Naïve
⦁	ETS (Error–Trend–Seasonal) models
⦁	ARIMA using ACF/PACF + AIC/BIC model selection

4.2 Exogenous Variables (ARIMAX)

⦁	Exogenous drivers included:
⦁	Mortgage interest rate (RBNZ B20 series)
⦁	Net migration (Stats NZ)
⦁	Auckland building consents
⦁	(Optional) Filled jobs, real estate listings

4.3 Forecast Evaluation

A rolling-origin evaluation was used with forecast horizons:

⦁	1 month ahead
⦁	3 months ahead
⦁	6 months ahead
⦁	12 months ahead

Evaluation metrics:

⦁	Mean Absolute Error (MAE)
⦁	Root Mean Squared Error (RMSE)
⦁	Mean Absolute Percentage Error (MAPE)
⦁	Diebold–Mariano (DM) tests for statistical comparison

📈5. Results

1. ARIMA models performed strongly for short-term horizons (1–3 months).
They captured trend and seasonality well but lacked economic context.

2. ARIMAX models outperformed all baselines for 6–12 month horizons.
Mortgage rates and migration provided meaningful predictive power.

3. ETS models underperformed in regimes with structural changes.

For example:
⦁	Introduction of Auckland Unitary Plan
⦁	COVID-19 pandemic disruptions

4. DM tests confirmed ARIMAX’s statistical improvement (p < 0.05) especially at longer horizons.

🛠6. Tools

⦁	Python: pandas, numpy, statsmodels, matplotlib
⦁	Time-Series: ARIMA, SARIMAX, ETS, rolling-origin evaluation
⦁	Statistical Testing: Diebold–Mariano test
⦁	Jupyter Notebook for reproducible analysis
⦁	GitHub for version control and documentation

🎓7. What I Learned

⦁	How to build a full forecasting pipeline in Python
⦁	How to incorporate economic drivers into ARIMAX
⦁	Advanced time-series evaluation using rolling-origin tests
⦁	How policy changes and economic shocks affect HPI dynamics
⦁	How to write a fully structured research report (full PDF included)

🚀8. Future Improvements

⦁	Add machine-learning models (Random Forest, XGBoost)
⦁	Explore dynamic regression & state-space models
⦁	Include policy event dummies (AUP, LVR changes, COVID alerts)
⦁	Build a simple interactive dashboard (Streamlit or Tableau)
