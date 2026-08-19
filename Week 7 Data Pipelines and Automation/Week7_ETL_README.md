# Week 7: Weather Data ETL Pipeline

## Project Overview

This project demonstrates a complete **ETL (Extract, Transform, Load)** pipeline using real-time weather data from the OpenWeather API. The pipeline extracts current weather information for three major cities, transforms it into a clean, analysis-ready format, and loads it into both CSV and SQLite database formats for downstream analysis.

**Objective:** Build a practical ETL workflow that showcases data collection, transformation, and storage skills in a real-world scenario.

---

## Data Source

**API:** OpenWeather API (https://openweathermap.org/api)

**Cities Analyzed:**
- Lagos, Nigeria
- London, United Kingdom
- New York, USA

**Data Retrieved:**
- City Name
- Temperature (Celsius)
- Humidity (%)
- Weather Condition
- Wind Speed (m/s)
- Date and Time (UTC)

**Access Method:** Free tier OpenWeather API with personal API key authentication

---

## ETL Process

### Task 1: Extract
**Objective:** Retrieve raw weather data from the OpenWeather API

**Method:**
- Loop through each city name
- Send HTTP GET requests to the OpenWeather API endpoint
- Include API key and units parameter (metric for Celsius)
- Collect successful responses (status code 200) into a list
- Store raw JSON data for transformation

**Code Example:**
```python
cities = ["Lagos", "London", "New York"]
raw_data = []

for city in cities:
    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
    response = requests.get(url)
    if response.status_code == 200:
        raw_data.append(response.json())
        print(f"✓ Got data for {city}")
    else:
        print(f"✗ Failed for {city}: {response.status_code}")
```

### Task 2: Transform
**Objective:** Clean and flatten the nested JSON data into a structured table

**Method:**
- Parse each raw JSON response
- Extract only required fields from deeply nested structure
- Convert timestamps to readable datetime format
- Standardize field names and data types
- Create a pandas DataFrame for easy analysis

**Data Extracted:**
| Field | Source | Transformation |
|-------|--------|-----------------|
| City | data["name"] | Direct copy |
| Temperature_C | data["main"]["temp"] | Direct copy |
| Humidity_% | data["main"]["humidity"] | Direct copy |
| Weather_Condition | data["weather"][0]["description"] | Extract first element |
| Wind_Speed_ms | data["wind"]["speed"] | Direct copy |
| DateTime | data["dt"] | Convert Unix timestamp to datetime |

**Code Example:**
```python
records = []
for data in raw_data:
    records.append({
        "City": data["name"],
        "Temperature_C": data["main"]["temp"],
        "Humidity_%": data["main"]["humidity"],
        "Weather_Condition": data["weather"][0]["description"],
        "Wind_Speed_ms": data["wind"]["speed"],
        "DateTime": datetime.fromtimestamp(data["dt"])
    })

df = pd.DataFrame(records)
```

### Task 3: Load
**Objective:** Store transformed data in multiple formats for accessibility

**Method:**
- **CSV Format:** Save as plain text CSV file for universal compatibility
- **SQLite Database:** Store in lightweight, file-based database for SQL querying capabilities

**Code Example:**
```python
# Save as CSV
df.to_csv("weather_data.csv", index=False)

# Save to SQLite
import sqlite3
conn = sqlite3.connect("weather_data.db")
df.to_sql("weather", conn, if_exists="replace", index=False)
conn.close()
```

**Output Files:**
- `weather_data.csv` — Comma-separated values file
- `weather_data.db` — SQLite database with "weather" table

---

## Tools Used

- **Python 3.x** — Programming language
- **Pandas** — Data manipulation and DataFrame operations
- **Requests** — HTTP library for API calls
- **SQLite3** — Lightweight database management
- **Jupyter Notebook** — Development and documentation environment
- **OpenWeather API** — Real-time weather data source

---

## Steps Taken

### 1. Setup & Authentication
- Created free OpenWeather API account
- Generated personal API key
- Stored API key securely in Python environment variable

### 2. Extract Phase
- Defined list of target cities
- Looped through each city and sent API requests
- Validated HTTP responses (status code 200 = success)
- Collected raw JSON responses

### 3. Transform Phase
- Parsed nested JSON structure
- Extracted relevant fields into flat dictionary format
- Converted timestamp to human-readable datetime
- Created pandas DataFrame from cleaned records

### 4. Load Phase
- Saved transformed data to CSV file
- Created SQLite database and loaded data into "weather" table
- Verified file creation in working directory

### 5. Basic Analysis
- Compared temperatures across three cities
- Identified city with highest humidity
- Examined weather conditions for each location

---

## Key Findings

### Temperature Comparison
- **Hottest:** Lagos at 28.57°C
- **Moderate:** London at 25.63°C
- **Coolest:** New York at 21.87°C

**Insight:** Lagos is 6.7°C warmer than New York, reflecting geographic and seasonal differences between tropical Africa and northern North America.

### Humidity Analysis
- **Highest Humidity:** New York at 95%
- **Moderate:** Lagos and London at similar levels

**Insight:** New York's high humidity suggests recent rainfall or marine influence; coastal cities typically show higher humidity levels.

### Weather Conditions
- All three cities reported **cloudy conditions** (broken clouds or overcast)
- No precipitation reported at time of data collection

**Insight:** Cloud cover is a global pattern across these diverse geographic regions, suggesting a weather system or seasonal pattern affecting all three cities simultaneously.

---

## Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| API rate limiting | Used free tier responsibly; added 1-second delays between requests |
| Nested JSON structure | Used dictionary key navigation and list indexing to extract nested values |
| Timestamp format | Used `datetime.fromtimestamp()` to convert Unix epoch to readable format |
| Data validation | Added HTTP status code checking to catch failed requests early |

---

## Skills Demonstrated

✅ API integration and HTTP requests  
✅ JSON parsing and data extraction  
✅ Pandas DataFrame manipulation  
✅ Data cleaning and standardization  
✅ CSV and SQLite database operations  
✅ Error handling and validation  
✅ ETL pipeline architecture  
✅ Data analysis and interpretation  

---

## How to Run This Project

1. **Install dependencies:**
   ```bash
   pip install pandas requests
   ```

2. **Set up API key:**
   - Sign up at https://openweathermap.org/api
   - Generate an API key
   - Set environment variable: `export OPENWEATHER_API_KEY="your_key_here"`

3. **Run the notebook:**
   - Open the Jupyter notebook
   - Update the cities list if desired
   - Run all cells sequentially

4. **Check outputs:**
   - `weather_data.csv` — viewable in Excel or text editor
   - `weather_data.db` — queryable via SQLite client

---

## Next Steps & Recommendations

1. **Automate:** Schedule this pipeline to run daily/hourly using a task scheduler (cron on Linux, Task Scheduler on Windows)
2. **Expand:** Add more cities or weather parameters (pressure, visibility, UV index)
3. **Visualize:** Create Power BI or Tableau dashboards from the collected data
4. **Archive:** Store historical data to track weather trends over time
5. **Alert:** Add conditional logic to send alerts if temperature exceeds thresholds

---

## Conclusion

This ETL pipeline demonstrates a practical, end-to-end data workflow — extracting real-time data from an external API, transforming it into a clean, usable format, and storing it for analysis. The skills applied here (API integration, data transformation, database loading) are foundational for any data engineer or analyst working with modern data sources.

---

**Submitted as part of AnalystLab Africa Data Analytics Internship — Week 7**

*Built: [Date]*  
*Dataset: OpenWeather API (Real-time)*  
*Technologies: Python, Pandas, SQLite*
