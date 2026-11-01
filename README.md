# 🎮 Video Game Sales Analytics (R Shiny Dashboard)

An interactive data visualization dashboard built with **R**, **R Shiny**, and **Plotly** to analyze global video game sales patterns across platforms, genres, publishers, and geographical regions.

---

## 🌐 Live Application & Repositories

- 🔵 **Live R Shiny App**: [https://sasenasea05.shinyapps.io/r_app/](https://sasenasea05.shinyapps.io/r_app/)
- 🌾 **Python Version (Streamlit)**: [https://github.com/sasenasea05/paddy-doctor-data-visualization](https://github.com/sasenasea05/paddy-doctor-data-visualization)

---

## 📌 Project Overview & Dataset

This dashboard analyzes over **16,000 historical records** of video game sales performance (games with sales greater than 100,000 copies).

- **Dataset Source**: Kaggle - [Video Game Sales Dataset](https://www.kaggle.com/datasets/gregorut/videogamesales)
- **Data Volume**: 16,598 records and 11 features
- **Key Variables**:
  - `Platform` (PS4, X360, PC, Wii, NES, etc.)
  - `Genre` (Action, Sports, Shooter, Role-Playing, etc.)
  - `Publisher` (Nintendo, Electronic Arts, Activision, etc.)
  - `Sales Regions` (NA_Sales, EU_Sales, JP_Sales, Other_Sales, Global_Sales)

---

## ✨ Key Features & Charts

The interactive dashboard includes **4 KPI summary metrics**, **2 dynamic filters**, and **6 interactive visualizations**:

1. 📊 **Top 10 Genres by Global Sales** *(Bar Chart)*: Identifies the highest-grossing game genres globally.
2. 📈 **Global Sales Trend per Year** *(Line Chart)*: Tracks overall industry revenue trajectories over time.
3. 🍩 **Regional Sales Composition** *(Donut Chart)*: Displays market share breakdown across North America, Europe, Japan, and Other regions.
4. 🏢 **Top 10 Publishers Performance** *(Horizontal Bar Chart)*: Highlights lead gaming publishers based on total sales volume.
5. 🎮 **Regional Breakdown on Top Platforms** *(Stacked Bar Chart)*: Compares regional market shares across the top 5 gaming platforms.
6. 🎯 **NA vs EU Sales Correlation** *(Scatter Plot)*: Explores market relationships and demand patterns between North America and Europe.

---

## 💡 Key Data Insights

- **Market Dominance**: North America (**NA**) and Europe (**EU**) represent the vast majority of global video game revenue.
- **Top Genres**: **Action** and **Sports** genres consistently dominate overall cumulative sales across multiple hardware generations.
- **Publisher Impact**: Legacy industry leaders like **Nintendo**, **Electronic Arts (EA)**, and **Activision** lead the global sales volume charts.

---

## 🛠️ Tech Stack & Dependencies

- **Language**: R (v4.4.x)
- **Dashboard Framework**: `shiny` & `shinydashboard`
- **Data Manipulation**: `tidyverse` (`dplyr`, `readr`, `tidyr`, `ggplot2`)
- **Interactivity**: `plotly`
- **Deployment**: `rsconnect` (Shinyapps.io)

---

## 🚀 How to Run Locally

### Prerequisites
Make sure you have **R** and **RStudio** installed on your machine.

### Instructions

1. **Clone the repository**:
   ```bash
   git clone [https://github.com/sasenasea05/video-game-sales-analytics.git](https://github.com/sasenasea05/video-game-sales-analytics.git)
   cd video-game-sales-analytics
