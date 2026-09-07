# Data Dictionary

## Columns (cleaned dataset)

| Column | Type | Description |
|---|---|---|
| `city` | text | Ghaziabad, Kanpur, or Lucknow |
| `title` | text | News article headline |
| `text` | text | Full news article text |
| `crime_category` | text | Derived: `Murder`, `Crime Against Women`, `Kidnapping`, or `Unclassified` |
| `total_victims` | integer | Derived: sum of all victim-count fields for the row |
| `murder_reason` | text | Reason code for murder cases (see legend below); `"Not Applicable"` for non-murder rows |
| `murder_child_victims` | integer | Child victims in a murder case |
| `murder_male_adult_victims` | integer | Adult male victims in a murder case |
| `murder_female_adult_victims` | integer | Adult female victims in a murder case |
| `kidnap_child_victims` | integer | Child victims in a kidnapping case |
| `kidnap_male_adult_victims` | integer | Adult male victims in a kidnapping case |
| `kidnap_female_adult_victims` | integer | Adult female victims in a kidnapping case |
| `crime_against_women_type` | text | Comma-separated category code(s) (see legend below); `"Not Applicable"` for non-crime-against-women rows |
| `total_adult_victims` | integer | Total adult victims across all crime types for the row |
| `total_child_victims` | integer | Total child victims across all crime types for the row |

## Murder Reason Legend
| Label |
|---|
| Property/Land Disputes |
| Family Dispute |
| Petty Quarrels |
| Money Disputes |
| Personal Vendetta |
| Love Affairs |
| Casteism |
| Unknown/other |

## Crime Against Women — Category Legend
| Code | Label |
|---|---|
| 1 | Murder with Rape |
| 2 | Dowry Deaths (Sec. 304B) |
| 3 | Suicide (Sec. 305/306) |
| 4 | Kidnapping (All) |
| 5 | Acid Attack (Sec. 326A IPC) |
| 6 | Cruelty by Husband/in-laws (Sec. 498A IPC) |
| 7 | Rape only (Sec. 376 or 511 IPC) |
| 8 | Assault on Women with Intent to Outrage Modesty (Sec. 354 IPC) |
| 9 | Cyber Crimes against Women |
| 10 | Protection of Children from Sexual Offences Act (POCSO) |
| — | `Other/Undocumented`: code `11` appeared in the raw data but falls outside the original 1–10 legend. Rather than guess its intended meaning, these rows are explicitly labeled as an undocumented/other category. |

Some rows contain multiple comma-separated codes (e.g. `"2,3,6"`), meaning a single incident was coded under more than one category.

## Key Cleaning Decisions
- **Missing values**: Numeric victim-count columns were filled with `0`
  (meaning "not applicable to this row," not "unknown"). Category columns
  were filled with `"Not Applicable"`.
- **Label inconsistencies**: Raw values like `"Unknown reasons"` and
  `"Property Disputes"` were standardized to match the legend
  (`"Unknown/other"`, `"Property/Land Disputes"`).
- **Victim total mismatch**: `total_adult_victims`/`total_child_victims`
  are combined totals across all three crime types (murder, kidnapping,
  crime-against-women), but individual male/female breakdown columns only
  exist for murder and kidnapping. This means the sum of the individual
  breakdown columns will not equal the total for rows that include a
  crime-against-women component — this is a structural limitation of the
  source data, not a data entry error.
- **Outlier verification**: Cases with high victim counts (up to 10) were
  manually checked against their source article text and confirmed to be
  genuine high-casualty events (e.g. a shooting spree), not data errors.
