/* === MATH803 - Project-B === */

/* === 1a === */

/* Import Excel data */
proc import datafile="/home/u64175686/sasuser.v94/MATH803/NorthIslandHourlyElec2-1.xlsx"
    out=elec_data
    dbms=xlsx
    replace;
    sheet="Sheet1";
    getnames=yes;
run;

/* === 1b === */

/* Step 1: Clean the data */
data elec_data_clean;
    set elec_data;

    /* Convert string to datetime, strip quotes */
    DateTime = input(compress(Date, "'"), anydtdtm.);
    format DateTime datetime20.;

    /* Extract DateOnly and Hour */
    DateOnly = datepart(DateTime);
    format DateOnly date9.;
    Hour = hour(DateTime);
run;

/* Step 2: Ensure non-missing MW values */
proc means data=elec_data_clean n nmiss;
    var MW DateTime;
run;

/* Step 3: Sort before plotting */
proc sort data=elec_data_clean;
    by DateTime;
run;

/* Step 4: Plot */
proc sgplot data=elec_data_clean;
    series x=DateTime y=MW / lineattrs=(thickness=1);
    xaxis label="Date and Time";
    yaxis label="Electricity Demand (MW)";
    title "Hourly Electricity Demand from March to May 2020";
run;

/* === 2a === */

/* Step 1: Fit multiple linear regression model */
proc glm data=elec_data_clean plots=diagnostics;
    class Hour;
    model MW = Temperature WindSpeed Hour / solution;
    output out=reg_out p=Predicted r=Residual;
    title "Time Series Regression Model for Hourly Electricity Demand";
run;

/* Step 2: Generate 7-day (168-hour) forecast input manually */
data forecast_input;
    format DateTime datetime20. DateOnly date9.;
    do i = 1 to 168;
        DateTime = '01JUN2020:00:00:00'dt + (i - 1)*3600; /* 1-hour step */
        Hour = hour(DateTime);
        DateOnly = datepart(DateTime);
        Temperature = 15; /* Replace with assumed or average values */
        WindSpeed = 5;    /* Replace with assumed or average values */
        output;
    end;
run;

/* Step 3: Store model from PROC GLM */
proc glm data=elec_data_clean;
    class Hour;
    model MW = Temperature WindSpeed Hour;
    store out=reg_model;
run;

/* Step 4: Apply stored model to forecast_input */
proc plm restore=reg_model;
    score data=forecast_input out=reg_forecast predicted=Forecast_MW;
run;

/* Step 5: Plot the forecast */
proc sgplot data=reg_forecast;
    series x=DateTime y=Forecast_MW / lineattrs=(thickness=2);
    xaxis label="DateTime";
    yaxis label="Forecasted Electricity Demand (MW)";
    title "7-Day Forecast Using Time Series Regression Model";
run;

/* === 2b === */

/* Step 1: Sort and Prepare Data */
proc sort data=elec_data_clean;
    by DateTime;
run;

proc timeseries data=elec_data_clean out=ts_hourly;
    id DateTime interval=hour;
    var MW;
run;

/* Step 2: Fit Additive Seasonal Exponential Smoothing Model */
proc esm data=ts_hourly 
         out=esm_hw_add 
         outfor=esm_forecast 
         outest=esm_betas 
         lead=168 
         print=all 
         plot=(forecasts modelforecasts);
    id DateTime interval=hour;
    forecast MW / model=addwinters;
run;

/* Step 3: Plot Forecasted Values */
title1 "Additive Holt-Winters Forecast – Electricity Demand";
proc sgplot data=esm_forecast;
    series x=DateTime y=Predict / lineattrs=(color=blue);
    series x=DateTime y=Actual / lineattrs=(color=red);
    refline '01JUN2020:00:00:00'dt / axis=x;
    yaxis label="MW";
    xaxis label="DateTime";
run;

/* === 3a === */

/* Step 1: Sort the data by time */
proc sort data=elec_data_clean;
    by DateTime;
run;

/* Step 2: Identification – Check Stationarity with ADF Test */
proc arima data=elec_data_clean;
    identify var=MW stationarity=(adf=1);
run; quit;

/* Step 3: Model Identification via ACF/PACF */
/* Identification – ACF/PACF */
proc arima data=elec_data_clean;
    identify var=MW nlag=48; 
run;
quit;

/* Estimation - Initial Attempt with  ARMA(1,1)  */
proc arima data=elec_data_clean;
    identify var=MW;
    estimate p=1 q=1 method=ML;
run;

/* Step 4: Refine the Model with ARIMA(1,0,1)(1,0,1)[24] */
proc arima data=elec_data_clean;
    identify var=MW(1,24) nlag=48; /* Apply both non-seasonal and seasonal differencing */
    estimate p=1 q=1 P=1 Q=1 method=ML;
run;
quit;

/* Step 5: Forecast 7 Days Ahead Using the Fitted Seasonal ARIMA Model */
proc arima data=elec_data_clean;
    identify var=MW(1,24);
    estimate p=1 q=1 P=1 Q=1 method=ML;
    forecast lead=168 interval=hour id=DateTime out=forecast_MW;
run; quit;

/* === 3b === */

/* Step 1: Check cross-correlation */
proc arima data=elec_data_clean;
    identify var=MW crosscorr=(Temperature WindSpeed);
run; quit;

/* Step 2: Differencing for stationarity */
proc arima data=elec_data_clean;
    identify var=MW(1,24) crosscorr=(Temperature WindSpeed);
run; quit;

/* Step 3: Estimate ARIMAX model with inputs */
proc arima data=elec_data_clean;
    identify var=MW(1,24) crosscorr=(Temperature WindSpeed);
    estimate p=1 q=1 input=(Temperature WindSpeed) method=ML;
    forecast lead=168 interval=hour id=DateTime out=forecast_arimax;
run; quit;

/* Step 4: Plot 7-Day Forecast from ARIMAX Model */
proc sgplot data=forecast_arimax;
    where DateTime >= '25MAY2020:00:00:00'dt and DateTime < '01JUN2020:00:00:00'dt;
    series x=DateTime y=forecast / lineattrs=(thickness=2);
    xaxis label="DateTime";
    yaxis label="Forecasted MW";
    title "7-Day Forecast Using ARIMAX Model";
run;

/* === 4a === */

data train_set test_set;
    set elec_data_clean;
    if DateTime < '25MAY2020:00:00:00'dt then output train_set;
    else if DateTime < '01JUN2020:00:00:00'dt then output test_set;
run;

/* === 4b === */

/* ARIMA */
data forecast_arima_7d;
    set forecast_MW;
    if '25MAY2020:00:00:00'dt <= DateTime < '01JUN2020:00:00:00'dt;
run;

data compare_arima;
    merge test_set(in=a) forecast_arima_7d(in=b);
    by DateTime;
    if a and b;
run;

%forecast_accuracy(modelname=ARIMA, compare_ds=compare_arima);

/* ARIMAX */
data forecast_arimax_7d;
    set forecast_arimax;
    if '25MAY2020:00:00:00'dt <= DateTime < '01JUN2020:00:00:00'dt;
run;

data compare_arimax;
    merge test_set(in=a) forecast_arimax_7d(in=b);
    by DateTime;
    if a and b;
run;

%forecast_accuracy(modelname=ARIMAX, compare_ds=compare_arimax);

/* Time Series Regression */
data forecast_input_holdout;
    format DateTime datetime20. DateOnly date9.;
    do i = 1 to 168;
        DateTime = '25MAY2020:00:00:00'dt + (i - 1)*3600;
        Hour = hour(DateTime); DateOnly = datepart(DateTime);
        Temperature = 15; WindSpeed = 5; output;
    end;
run;

proc plm restore=reg_model;
    score data=forecast_input_holdout out=reg_forecast_7d predicted=forecast;
run;

data compare_reg;
    merge test_set(in=a) reg_forecast_7d(in=b);
    by DateTime;
    if a and b;
run;

%forecast_accuracy(modelname=Regression, compare_ds=compare_reg);

/* Exponential Smoothing */
data esm_forecast_7d;
    set esm_forecast;
    if '25MAY2020:00:00:00'dt <= DateTime < '01JUN2020:00:00:00'dt;
    rename Predict=forecast;
run;

data compare_esm;
    merge test_set(in=a) esm_forecast_7d(in=b);
    by DateTime;
    if a and b;
run;

%forecast_accuracy(modelname=ExpSmoothing, compare_ds=compare_esm);

/* Summary Table */
data metrics_arima;
    length Method $20;
    Method = "ARIMA";  /* Create first to force it as the first column */
    set compare_arima end=last;
    retain mae mape mse;
    mae + abs(err);
    mape + abs_pct_err;
    mse + err_sq;
    if last then do;
        mae = mae / _N_;
        mape = mape / _N_;
        mse = mse / _N_;
        rmse = sqrt(mse);
        output;
    end;
    keep Method mae mape mse rmse;
run;

data all_metrics;
    set metrics_ARIMA metrics_ARIMAX metrics_Regression metrics_ExpSmoothing;
run;

proc print data=all_metrics noobs label;
    title "Comparison of Forecasting Models'/Methods' Accuracy ";
    label 
        Method = "Forecasting Method"
        MAE = "Mean Absolute Error (MAE)"
        MAPE = "Mean Absolute Percentage Error (MAPE)"
        MSE = "Mean Squared Error (MSE)"
        RMSE = "Root Mean Squared Error (RMSE)";
run;