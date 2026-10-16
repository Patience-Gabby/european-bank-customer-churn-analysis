# European Bank Customer Churn Analysis
# Exploratory Data Analysis using Python and Pandas

import pandas as pd
import matplotlib.pyplot as plt

# Load dataset
df = pd.read_csv("Bank_Churn.csv")

# 1. Understand the dataset
print("First five rows:")
print(df.head())

print("\nDataset shape:")
print(df.shape)

print("\nColumn information:")
df.info()

# 2. Data quality checks
print("\nMissing values per column:")
print(df.isnull().sum())

print("\nDuplicate rows:")
print(df.duplicated().sum())

print("\nDuplicate customer IDs:")
print(df["CustomerId"].duplicated().sum())

# 3. Overall churn
print("\nCustomer counts by churn status:")
print(df["Exited"].value_counts().sort_index())

churn_rate = df["Exited"].mean() * 100
print(f"\nOverall churn rate: {churn_rate:.2f}%")

# 4. Churn by geography
country_summary = (
    df.groupby("Geography")
    .agg(
        total_customers=("Exited", "size"),
        churned_customers=("Exited", "sum"),
        churn_rate=("Exited", "mean")
    )
)

country_summary["churn_rate"] *= 100

print("\nChurn by geography:")
print(country_summary.sort_values("churn_rate", ascending=False))

# 5. Churn by gender
gender_summary = df.groupby("Gender")["Exited"].agg(
    total_customers="size",
    churned_customers="sum",
    churn_rate="mean"
)

gender_summary["churn_rate"] *= 100

print("\nChurn by gender:")
print(gender_summary)

# 6. Churn by activity status
activity_summary = df.groupby("IsActiveMember")["Exited"].agg(
    total_customers="size",
    churned_customers="sum",
    churn_rate="mean"
)

activity_summary["churn_rate"] *= 100

print("\nChurn by activity status:")
print(activity_summary)

# 7. Churn by number of products
product_summary = df.groupby("NumOfProducts")["Exited"].agg(
    total_customers="size",
    churned_customers="sum",
    churn_rate="mean"
)

product_summary["churn_rate"] *= 100

print("\nChurn by number of products:")
print(product_summary)

# 8. Create age groups
df["AgeGroup"] = pd.cut(
    df["Age"],
    bins=[17, 30, 40, 50, 100],
    labels=["18-30", "31-40", "41-50", "51+"]
)

age_summary = df.groupby("AgeGroup", observed=False)["Exited"].agg(
    total_customers="size",
    churned_customers="sum",
    churn_rate="mean"
)

age_summary["churn_rate"] *= 100

print("\nChurn by age group:")
print(age_summary)

# 9. Compare average balance and salary by churn status
print("\nAverage balance by churn status:")
print(df.groupby("Exited")["Balance"].mean())

print("\nAverage estimated salary by churn status:")
print(df.groupby("Exited")["EstimatedSalary"].mean())

# 10. Visualise churn rate by geography
country_summary["churn_rate"].sort_values().plot(
    kind="bar",
    title="Customer Churn Rate by Geography",
    ylabel="Churn Rate (%)",
    xlabel="Geography"
)

plt.tight_layout()
plt.show()
