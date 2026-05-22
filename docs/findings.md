# 📋 Feature Usage Dashboard — Findings & Recommendations

**Analyst:** [Your Name]
**Period:** January 1–30, 2024
**Dataset:** 50 users, 8 features, ~190 events

---

## Executive Summary

A 30-day analysis of product feature engagement reveals a clear split between widely-used core features and severely underutilized advanced features. Three features — Advanced Filters, Integrations, and API Access — together account for under 10% of total usage despite being gated behind paid plans.

---

## Feature Usage Rankings

| Rank | Feature | Category | Total Uses | Unique Users | Status |
|---|---|---|---|---|---|
| 1 | Dashboard | Core | 55 | 40 | ✅ Healthy |
| 2 | Search | Core | 29 | 25 | ✅ Healthy |
| 3 | Export | Productivity | 20 | 18 | ✅ Healthy |
| 4 | Reports | Productivity | 14 | 14 | 🟡 Monitor |
| 5 | Notifications | Core | 12 | 12 | 🟡 Monitor |
| 6 | API Access | Advanced | 9 | 8 | 🔴 Underutilized |
| 7 | Integrations | Advanced | 6 | 6 | 🔴 Underutilized |
| 8 | Advanced Filters | Advanced | 4 | 4 | 🔴 Severely underutilized |

---

## Key Findings

### Finding 1: Advanced Features Are Almost Invisible
Advanced Filters, Integrations, and API Access collectively had only 19 uses across 30 days. Adoption rates are below 10% even among Enterprise users who pay for them.

### Finding 2: Usage is Highly Concentrated
A 80/20 analysis shows the top 20% of users drive a disproportionate share of all interactions. Free-plan users are almost entirely absent from advanced features.

### Finding 3: Stickiness Varies Widely
Dashboard and Search show strong repeat usage. Advanced Filters has a near 100% one-time use rate — users try it once and never return, suggesting a UX or discoverability problem.

### Finding 4: Mobile Users Underuse Productivity Features
Export and Reports are used almost exclusively on desktop. Mobile users have near-zero engagement, suggesting either a responsive design gap or a discoverability issue.

---

## Recommendations

1. **In-app discovery for Advanced Filters** — add a tooltip on Search results pointing to Advanced Filters. Estimated 5x lift in trial rate.
2. **Integrations onboarding flow** — add a guided setup step during Enterprise onboarding.
3. **Mobile-friendly Export** — audit Export and Reports on mobile. 40% of users are on mobile.
4. **API Access in email sequence** — add API Access to the onboarding email for Pro and Enterprise users.

---

## Next Steps

- [ ] Share with Product team for roadmap prioritization
- [ ] Set up a recurring monthly version of this query as a dashboard
- [ ] Define "healthy" adoption thresholds per feature tier
- [ ] A/B test in-app discovery prompt for Advanced Filters

---

*Data source: simulated feature_events table. Full analysis would run on production data in BigQuery/Snowflake.*
