# Ironhack-Final-Project
# Credit Risk Analysis – Final Project

**Author:** Maen Khaled  
**GitHub Repository:** [Ironhack-Final-Project](https://github.com/MaenKhaled/Ironhack-Final-Project)  
**Dataset:** [Credit Risk Dataset – Kaggle](https://www.kaggle.com/datasets/laotse/credit-risk-dataset)  
** Presentation slides:** [Maen Khaled - Final Project](https://docs.google.com/presentation/d/1x-T-2yvn-KwSWlaNDqSzj92yYGUdDhkA5ocVbcoW560/edit?slide=id.g36454e8b1b6_1_197#slide=id.g36454e8b1b6_1_197)

---

## 📌 Problem Statement
Banks face the ongoing challenge of accurately predicting whether a customer will repay a loan.  
- **Incorrect approvals** → High financial risk from defaults.  
- **Overly strict rejections** → Loss of potential good customers.  

**Objective:**  
Build a classification model to predict loan approval status, achieving the best balance between reducing potential defaults and retaining good customers. Store processed data in a relational database for future analysis.

---

## 📊 Data Overview
- **Source:** Kaggle  
- **Shape:** 32,580 rows × 12 columns  
- **Target Variable:** `loan_status` (Boolean: defaulted or not)  
- **Key Features:** `person_income`, `loan_int_rate`, `person_age`  

---

## 🧹 Data Cleaning
- **Outliers:** Capped extreme values.  
- **Data types:** Validated and corrected.  
- **Loan grade:** Categories `E`, `F`, `G` merged into `E_or_lower`.  
- **Categorical encoding:** Mapped and lowercased all string categories.  
- **Duplicates:** <0.5% removed (no unique ID column present).  
- **Missing values:**  
  - `person_emp_length` → Filled with mode.  
  - `loan_int_rate` → Imputed using `RandomForestRegressor`.

---

## 🔍 Exploratory Data Analysis (EDA)
- **Target imbalance:**  
  - 78% non-default (False)  
  - 22% default (True)  
- **Insights:**  
  - Lower income correlates with higher default rates.  
  - Higher interest rates increase default likelihood.  

---

## 🧠 Data Modeling Approach
### Preprocessing
- One-hot encoding for nominal features.  
- Ordinal encoding for `loan_grade`.  
- Boolean to integer conversion for target.  
- Feature scaling for numerical features (excluding binary-encoded).  
- Train/test split: 80% / 20%.

### Models Tested
| Model | ROC-AUC | Notes |
|-------|--------|-------|
| **KNN** | 0.87 | Good for non-default detection, weaker recall for defaults. |
| **Logistic Regression** | 0.87 | Balanced but low precision for defaults. |
| **Random Forest** | 0.94 | Strong overall performance. |
| **LGBM Classifier** | 0.94 | Best balance between precision and recall. |

### Feature Engineering
- **`risk_tier`** = `loan_grade_numeric * loan_int_rate`  
- **`income_adequacy`** = `(person_income_log / loan_amount_log) + 1`  
- **`debt_burden`** = `sqrt(loan_amount_log) * loan_to_income_ratio`  

---

## 🗄 MySQL Database
ERD includes:
- **Customer** (`person_id`, age, income, home ownership, employment length)  
- **Loans** (`loan_id`, amount, interest rate, intent, grade, status, percent income)  
- **Credit Bureau** (`cb_id`, default history, credit history length)  

Example setup:
```sql
CREATE DATABASE IF NOT EXISTS credit_risk_project;
USE credit_risk_project;

CREATE TABLE Customer (
    person_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    person_age INT NOT NULL,
    person_income DECIMAL(12,2) NULL,
    person_home_ownership VARCHAR(255) NOT NULL,
    person_emp_length SMALLINT NULL
);

CREATE TABLE Loans (
    loan_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT UNSIGNED NOT NULL,
    loan_amnt DECIMAL(12,2) NOT NULL,
    loan_int_rate FLOAT(53) NULL,
    loan_intent VARCHAR(255) NOT NULL,
    loan_grade VARCHAR(255) NOT NULL,
    loan_status VARCHAR(255) NOT NULL,
    loan_percent_income DECIMAL(8,4) NOT NULL,
    CONSTRAINT loans_person_id_fk FOREIGN KEY (person_id) REFERENCES Customer(person_id)
);

CREATE TABLE credit_bureau (
    cb_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT UNSIGNED NOT NULL,
    cb_person_default_on_file VARCHAR(255) NOT NULL,
    cb_person_cred_hist_length INT NOT NULL,
    CONSTRAINT credit_bureau_person_id_fk FOREIGN KEY (person_id) REFERENCES Customer(person_id)
);
Conclusions

** Best Model: LGBM Classifier – most balanced trade-off between avoiding defaults and approving good customers.**

**Recommendation: Train on more balanced data to further improve recall for defaults**.

**Limitations: Downsampling and SMOTE not applied due to technical constraints.**

**Next Steps: Explore advanced balancing techniques and feature selection to boost performance**
Contact

Maen Khaled
📧 khaledmaen87@gmail.com
[LinkedIn](https://www.linkedin.com/in/maen-khaled-9b71941a5/)