# Prevention Programs and the CAS

← [Back to Getting Started](../GETTING_STARTED.md)

Your organization runs homeless prevention programs alongside your two emergency shelters. The CAS handles housing matching for shelter clients — prevention is a separate track. This guide explains where the two connect.

---

## What the CAS Does and Doesn't Handle

**The CAS handles:** Matching clients who are already homeless (in your emergency shelters) to available permanent housing.

**The CAS does not handle:** Prevention services — rental assistance, financial counseling, landlord mediation, or other interventions to keep people housed. These are managed in your HMIS as separate program enrollments.

You don't need to configure anything special in the CAS for prevention. Your prevention programs live entirely in your HMIS.

---

## Where Prevention and the CAS Connect

### When prevention succeeds

Prevention clients who remain housed never touch the CAS. Their program enrollment closes in your HMIS when the intervention ends.

### When prevention doesn't succeed

If a prevention client loses their housing despite your intervention, they may enter one of your emergency shelters. At that point, they transition from a prevention client to a shelter client — and become eligible for CAS matching.

**The transition:**

1. Client enters the family or individuals shelter
2. Staff enroll them in the shelter program in your HMIS (or intake them manually)
3. The client is added to the CAS — either via the nightly HMIS Warehouse sync or by importing them through the CSV template
4. They enter the matching queue with whatever homeless history they have accumulated

**Important:** Time spent in a prevention program does not count as time homeless. Only nights spent without stable housing (in shelter, unsheltered, or in temporary arrangements) count toward their priority score in the CAS. A client who was in prevention for 6 months and then entered the shelter starts their homeless clock from their shelter entry date — unless they had prior homeless history before the prevention program.

---

## Tracking Prevention Outcomes in Your HMIS

Even though prevention is outside the CAS, you should track outcomes carefully in your HMIS. This matters for two reasons:

1. **Reporting:** HUD and funders require prevention program outcome data (housing stability at 6 and 12 months after exit)
2. **Eligibility:** If a prevention client later becomes homeless, their prior enrollment history in your HMIS will be visible in the Warehouse and can affect their CAS client record

Recommended HMIS practice for prevention clients:
- Enroll them in the correct prevention project type (Homelessness Prevention, HUD definition)
- Exit with outcome: "Remained in permanent housing" (success) or the appropriate exit destination if they lost housing
- If they enter a shelter, create a new enrollment in the shelter project — don't extend the prevention enrollment

---

## Prevention as an Early Identification Tool

Your prevention program staff work with people who are at serious risk of becoming homeless. They often know months in advance when a prevention intervention is likely to fail.

Consider using this early warning time proactively:

- If a prevention client is likely to enter the shelter within 30–60 days, begin the CAS intake paperwork early
- Ensure they have a current housing assessment (VI-SPDAT or equivalent) on file
- Obtain a housing release consent form while they're still in the prevention program

When they do enter the shelter, they'll be ready to enter the matching queue immediately rather than waiting for intake to be completed.

---

## Rapid Re-Housing: The Bridge Between Prevention and Shelter

If your organization operates a **Rapid Re-Housing (RRH)** program, it can serve a dual role:

- **For people who are already homeless** (in your shelters): RRH is a CAS matching destination — configure it as a program with appropriate eligibility rules
- **For people at risk of homelessness**: RRH can also be offered as a prevention-adjacent intervention (diversion) to help someone secure new housing before entering shelter

In the CAS, RRH appears as a housing program just like PSH. Clients matched to RRH receive short-term rental assistance to move into private market housing, then transition to self-sufficiency.

If you run RRH as both a shelter exit and a diversion tool, track each use separately in your HMIS (shelter exit = CAS-matched, diversion = prevention program).

---

## Summary

| Situation | Where it lives |
|-----------|---------------|
| Client receiving prevention services | HMIS only — not in CAS |
| Prevention client loses housing, enters shelter | Import into CAS → enters matching queue |
| Prevention client remains housed | HMIS exit with stable housing outcome |
| RRH as shelter exit (client is homeless) | CAS matching program |
| RRH as diversion (client at risk, not yet homeless) | HMIS prevention program — not in CAS |
