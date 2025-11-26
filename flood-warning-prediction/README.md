# **🌧️ Flood Warning Prediction Using Machine Learning**



This project develops a machine-learning–based flood-warning prediction system using environmental and hydrological indicators. It includes evaluating MLP and LSTM approaches for river-level forecasting and flood classification.



## **🔍1. Project Overview**



This project builds and evaluates neural-network–based models to (1) forecast short-term river water levels and (2) classify flood events for the Puhinui @ Drop Structure monitoring site. The work compares Multilayer Perceptron (MLP) models (used for regression → thresholded to classify floods) and Long Short-Term Memory (LSTM) networks (for time-series regression), including systematic hyperparameter tuning and a case study over an ex-tropical cyclone event.

## **📂2. Project Structure**



flood-warning-prediction/

│

├── data/                     # # Raw dataset provided - Manukau csv data

├── scripts/                  # Notebook(s) and Python forecasting code

│   └── COMP809\_Assignment\_2\_Flood\_Prediction\_final.ipynb

├── report/

│   └── Assignment-2\_COMP809.pdf

├── figures/                  # Plots generated from the notebook

└── README.md                 # Project summary (this file)



## **📊3. Dataset**



* **Source**: Environmental Auckland Data Portal — Puhinui @ Drop Structure. Hourly observations from May 2020 – Apr 2025 (≈43,800 rows). Variables include river\_level\_m, river\_discharge\_m3s, rainfall\_manukau\_mm, rainfall\_puhinui\_mm, humidity\_pct, air\_temp\_C, wind\_speed\_ms, wind\_dir\_deg.
* **Missing values**: small gaps in river\_level\_m (62), river\_discharge\_m3s (61), large gaps in humidity\_pct and wind\_dir\_deg (~2,421). Missing values were handled with time-based interpolation (forward \& backward) to preserve temporal continuity.
* **Temporal resolution**: verified hourly; no duplicate timestamps.
* **Flood label**: defined by thresholding water-level at 2.5 m (99th-percentile / domain threshold), producing a strongly imbalanced target (≈99.0% no-flood, 1.0% flood).
* **Feature engineering**: 24-hour sliding window lookback, derived lag features, scaling/normalisation and train/validation/test chronological splits (70% train / 10% val / 20% test).



## **🧪4. Methods \& Models**



**MLP (sklearn MLPRegressor → classification by threshold)**



* Implemented MLP regressors trained to predict next 3-hour averaged river level (lookback = 24h, horizon = 3h).
* Baseline single hidden layer: 25 neurons, best learning rate 0.01 → R² ≈ 0.5896, MSE ≈ 0.0168 on test. Classification accuracy extremely high (~99.98%) due to class imbalance, but flood recall was low in baseline (recall ≈ 0.17) when thresholded.
* Two-layer experiments: distributed 25 neurons across two layers (various splits). Optimal split (12,13) produced slight gain: R² ≈ 0.5962, MSE ≈ 0.0166; classification accuracy remained high while minority-class detection stayed challenging without additional imbalance handling.



**LSTM (sequence regression)**



* LSTM trained for regression of river level using sequence input (lookback 24h). Extensive tuning performed:

 	- Epoch tuning found best epoch = 2 (early stopping rationale) despite runs up to 30 epochs.

 	- Batch-size tuning tested \[4,8,16,32,64]; batch size 64 chosen for stability and runtime trade-off.

 	- Neuron tuning recommended 32 neurons in hidden layer as a balance of accuracy and runtime.



* Final LSTM performance (regression): RMSE ≈ 0.0547, R² ≈ 0.74, substantially better than MLP for water-level forecasting (LSTM better captures temporal dependencies).



## **📏5. Evaluation \& metrics**



* **Regression metrics**: MAE, RMSE, R² computed on holdout test set (chronological split). LSTM gave superior regression scores (lower RMSE, higher R²).
* **Classification metrics**: thresholded regression outputs to classify floods; evaluated using Precision, Recall, F1, Confusion Matrix. MLP after some tuning improved recall in further experiments (some runs report recall ≈ 0.64), but this depends on architecture/tuning — initial baselines showed recall ≈ 0.17. Use case prioritises recall to avoid missed flood events.
* **Model selection**: models chosen based on a mix of regression accuracy (for forecasting) and classification sensitivity (for warnings). A hybrid approach is recommended (LSTM for continuous forecasts; MLP or tuned classifier for detection).



## **🔬6. Ex-tropical cyclone case study**



A focused test across the ex-tropical cyclone (18–20 April 2025) demonstrates operational performance: the tuned LSTM captured rapid river-level rise and peak timing, providing early warning during the storm; predictions closely tracked magnitude and timing around the peak (useful for real-time alerts). This illustrates practical utility for extreme events.



## **📈7. Results**



* **LSTM** (best config) → superior regression: R² ≈ 0.74, RMSE ≈ 0.0547.
* **MLP** (best two-layer split) → regression R² ≈ 0.5962, MSE ≈ 0.0166; classification accuracy high but minority-class recall requires targeted imbalance handling.
* **Operational takeaway:** LSTM best for accurate continuous forecasting; MLP variants or tuned classifiers are useful for detection, and a hybrid design (LSTM for regression + classifier for detection) is recommended.



## **🛠8. Tools**



* Python (Jupyter Notebook) — COMP809\_Assignment\_2\_Flood\_Prediction\_final.ipynb
* scikit-learn (MLPRegressor pipelines), TensorFlow/Keras for LSTM, pandas/numpy, matplotlib/seaborn.



## **🎓9. What I Learned**



Through this project I deepened my understanding of how to design, tune, and evaluate neural-network models for environmental time-series prediction. I learned how to perform end-to-end data preparation for sensor datasets including interpolation of missing values, feature engineering with sliding windows, and chronological splitting for forecasting tasks. I also gained practical experience contrasting MLP and LSTM architectures—seeing first-hand how LSTM networks capture temporal dependencies more effectively and why regression-to-classification pipelines struggle with extreme class imbalance. Finally, the cyclone case study taught me how to assess model behaviour during real extreme-weather events, reinforcing the importance of recall and lead-time accuracy for flood-warning systems.



## **🚀10. Future Improvements**



* **Class imbalance**: extremely rare flood events require dedicated imbalance strategies (SMOTE, cost-sensitive learning, anomaly detection) to raise recall without exploding false positives.
* **Hybrid pipeline**: combining LSTM regression with a classifier tuned for recall is promising (noted in conclusion).
* **Real-time deployment**: convert pipeline to streaming inference (API/Streamlit) and integrate live sensor feeds.



## 📘 **Academic Integrity Notice**



This project is original work developed by Thandar Kyi as part of coursework and research at Auckland University of Technology (AUT). It is available publicly for professional portfolio purposes only. Reuse, copying, or redistribution without attribution is not permitted.

