# Crime Data Analytics Pipeline

End-to-end data analytics pipeline analyzing compiled crime news reports
from three Uttar Pradesh cities — Ghaziabad, Kanpur, and Lucknow. Built to
demonstrate a full workflow: data cleaning, exploratory analysis, SQL
analytics, dashboarding, and a local AI agent for natural-language querying.

## Overview
The project takes a messy, manually compiled dataset of crime news
articles and turns it into a clean, structured, queryable resource —
covering data cleaning and preprocessing, exploratory data analysis (EDA),
PostgreSQL integration with SQL analytics, Power BI dashboards, and a
local retrieval-augmented generation (RAG) AI agent for natural-language
questions over the data.

## Dataset
- **Source**: Manually compiled from local news reports (title + article
  text), coded by crime category and victim counts
- **Size**: 466 records
- **Scope**: 3 cities only (Ghaziabad, Kanpur, Lucknow), no date field —
  a small, non-random sample. This is **not** a claim about actual crime
  rates in these cities; it's a compiled sample used for analytics practice.
- **Fields**: city, title, article text, murder reason category, murder/
  kidnapping victim counts by age and gender, crime-against-women category
  codes, total adult/child victims

### Note on sensitive content
This dataset includes real crime reports involving named victims,
including children. All analysis in this project stays at the
**aggregate/statistical level** (counts, percentages, category
breakdowns) rather than highlighting individual incidents, to avoid
sensationalizing real tragedies. The raw dataset is not included in this
repository — only the cleaned, structured version.

## Project Structure
```
crime-data-analytics-pipeline/
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   ├── interim/                 # step-by-step cleaning checkpoints
│   └── processed/
│       └── crime_data_clean.csv # final cleaned dataset
├── notebooks/
│   ├── crime_data_cleaning.ipynb
│   └── crime_data_eda.ipynb
├── sql/
│   └── crime_analysis_queries.sql
├── powerbi/                     # dashboard file (in progress)
├── agent/                       # RAG agent code
├── docs/
│   └── data_dictionary.md       # legend/codebook + cleaning decisions
└── outputs/
    └── figures/                 # exported EDA charts
```

## Pipeline Phases

### 1. Data Cleaning (`notebooks/crime_data_cleaning.ipynb`)
- Extracted coding legends that were embedded directly in raw column
  headers into separate reference dictionaries
- Renamed all columns to clean snake_case names
- Filled missing values: `0` for non-applicable numeric counts, `"Not
  Applicable"` for non-applicable categories
- Standardized inconsistent category labels (e.g. `"Unknown reasons"` →
  `"Unknown/other"`)
- Resolved comma-separated multi-code values and flagged an undocumented
  category code as `"Other/Undocumented"`
- Verified zero duplicate rows and zero negative values
- Diagnosed and documented a structural mismatch between reported victim
  totals and individual victim-count columns (crime-against-women cases
  lack a male/female breakdown in the source data — not a data error)
- Derived `total_victims` and `crime_category` summary fields

### 2. Exploratory Data Analysis (`notebooks/crime_data_eda.ipynb`)
- City-wise and category-wise case distributions
- Victim demographics by age and gender
- Murder reason breakdown
- Crime-against-women category breakdown, including a city comparison
  heatmap
- Total victims distribution with outlier investigation (verified
  high-victim cases as genuine events, not data errors)

### 3. PostgreSQL Integration (`sql/crime_analysis_queries.sql`)
- Loaded the cleaned dataset into a local `crime_analytics` PostgreSQL
  database via SQLAlchemy
- Wrote analytical SQL queries: case counts by city/category, murder
  reasons by city, total and average victims by city
- Resolved residual label inconsistencies directly in Postgres using
  `UPDATE ... CASE` statements

### 4. Power BI Dashboard (`powerbi/`)
In progress — connecting Power BI Desktop to the PostgreSQL database
to build interactive visuals (city/category breakdowns, murder reason
charts, crime-against-women heatmap, KPI summary cards).

### 5. AI Agent — Local RAG Pipeline (`agent/`)
- Built a retrieval-augmented generation agent for natural-language
  querying over the crime dataset, running entirely locally:
  - **Ollama** (in Docker) serving `llama3.2` for generation and
    `nomic-embed-text` for embeddings
  - **ChromaDB** as the local vector store
- Each record is converted into a descriptive text chunk and embedded
- User questions are embedded, matched against the most relevant records,
  and passed as context to the local LLM to generate a grounded answer
- Verified end-to-end with real queries (e.g. dowry-death cases in a
  specific city), returning accurate, context-grounded answers

## Tech Stack
- **Python** (pandas, numpy) — cleaning and preprocessing
- **Jupyter Notebook** — documented, step-by-step workflow
- **PostgreSQL** + SQLAlchemy/psycopg2 — structured storage and SQL analytics
- **Power BI** — dashboards and visual analysis (in progress)
- **Ollama + ChromaDB** — local RAG agent for natural-language querying

## How to Run
1. Clone the repo and install dependencies:
   ```
   pip install -r requirements.txt
   ```
2. Run `notebooks/crime_data_cleaning.ipynb`, then
   `notebooks/crime_data_eda.ipynb`
3. Set up PostgreSQL locally, create a `crime_analytics` database, and
   load the cleaned CSV using the provided notebook/SQL scripts
4. For the AI agent: start Ollama in Docker, pull `llama3.2` and
   `nomic-embed-text`, install `chromadb`, then run the agent notebook/script

## Limitations
- No date field — time-trend analysis isn't possible without extracting
  dates from article text
- Small, 3-city sample — not representative of broader crime patterns
- Manually compiled from news text — subject to transcription
  inconsistencies
- `total_adult_victims`/`total_child_victims` combine all three crime
  types, but individual gender/age breakdowns only exist for murder and
  kidnapping cases, not crime-against-women cases
- One category code (`11`) in `crime_against_women_type` fell outside the
  documented 1–10 legend and was labeled `"Other/Undocumented"`

## Status
Cleaning, EDA, PostgreSQL integration, and the RAG AI agent are complete.
Power BI dashboard is in progress.
