# Warrior beta ability reconciliation

Research snapshot only. This report proposes dispositions for owner review; it does not authorize catalogue, archive, spell-ID, detection, settings, or content changes.

## Sources and limitations

The primary [Warrior spellbook](https://wowforevertalent.com/abilities/warrior/) was retrieved on 16 October 2026. It identifies its source as the **16 October 2026 Forever Beta book, client 1.60.1.70425** and contains **117 recorded ranks grouped into 42 class-specific identities**: 14 Arms, 16 Fury, and 12 Protection. Eleven additional General-tab identities bring the source inventory to 53 identities and 128 tooltips. The page reports no Classic-fallback or name-only records, but it is not an in-game check and can change before launch.

The linked [Warrior talent reference](https://wowforevertalent.com/warrior/reference/) uses the **16 October 2026 Forever export** (`beta-20261016-56046fb6`). Its nine active talents—Spearing Strike, Sweeping Strikes, Mortal Strike, Piercing Howl, Death Wish, Bloodthirst, Last Stand, Concussion Blow, and Shield Slam—are all present in the spellbook. It supplies talent placement but no additional active identity.

The retrieved [changelog](https://wowforevertalent.com/changelog/) records the 2 October Warrior talent hotfixes and spellbook updates, the 3–4 October Spearing Strike stance/weapon corrections, and the 8 October talent refresh. No later entry contradicts the 16 October book. The site repeatedly warns that these records are not independently verified in game.

The primary pages expose names, ranks, train levels, acquisition notes, stance and weapon requirements, and activation timing, but not numeric game spell IDs. Candidate IDs in the CSV come from the repository's earlier mixed-source research inventory and remain unverified candidates; blank cells are intentional. Neither source proves readable successful-cast events in WoW Forever.

Source B is the actual `RPHelper.RegisterAbility` path in `RPHelper/Data/Abilities/Warrior.lua`. It defines **43 canonical identities and 21 authored reactions**: six `say`, six `emote`, and nine `customemote`; **31 definitions have empty shipped pools**. This research changes none of them.

## Reconciliation totals

The CSV retains all 53 beta records and all 43 RPHelper definitions. Thirty-nine identities overlap, while four historical definitions are absent from the current beta sources, producing **57 reconciled identities**.

| Classification | Identities | Authored reactions | Empty RPHelper definitions |
| --- | ---: | ---: | ---: |
| Confirmed, existing | 39 | 21 | 27 |
| Confirmed, missing | 14 | 0 | 0 |
| Not found in beta | 4 | 0 | 4 |
| **Total** | **57** | **21** | **31** |

Beta presence, activation eligibility, and v1 scope remain separate:

- The beta has 42 class identities and 11 General-tab identities.
- Of the class identities, **41 are direct player activations**. Tactical Mastery is passive.
- The 41 v1-eligible class identities comprise **35 confirmed existing** and **six confirmed missing**.
- All 11 General entries remain research evidence but are outside v1 scope. Four—Throw, Shoot Bow, Shoot Crossbow, and Shoot Gun—already exist in RPHelper; this does not override the General-tab policy.

## Confirmed existing coverage

The 35 v1-eligible exact class matches are Battle Shout, Berserker Rage, Bloodrage, Bloodthirst, Challenging Shout, Charge, Cleave, Concussion Blow, Death Wish, Demoralizing Shout, Disarm, Execute, Hamstring, Heroic Strike, Intercept, Intimidating Shout, Last Stand, Mocking Blow, Mortal Strike, Overpower, Piercing Howl, Pummel, Recklessness, Rend, Retaliation, Revenge, Shield Bash, Shield Block, Shield Slam, Shield Wall, Slam, Sunder Armor, Sweeping Strikes, Thunder Clap, and Whirlwind.

These 35 identities contain all 21 current Warrior reactions. Twelve have authored pools and 23 are empty. The remaining four exact matches are the existing General-tab ranged controls, all with empty pools.

## Missing active abilities

Six beta-confirmed direct activations are absent from RPHelper:

- **Battle Stance**, **Berserker Stance**, and **Defensive Stance** are manually activated stance changes with one-second cooldowns.
- **Spearing Strike** is an active Arms talent requiring Battle Stance and has target-type and mounted-target behavior.
- **Taunt** is a Defensive Stance activation with an eight-second cooldown.
- **Victory Rush** is a conditional activation usable shortly after killing a non-trivial enemy.

Tactical Mastery is the seventh missing class identity but is explicitly passive and outside direct-activation scope. The seven missing General identities are also outside v1 scope.

## Replacement, rename, and alias candidates

No rename is established strongly enough to merge automatically. Two comparisons require explicit review while remaining separate identities:

- Historical **Decisive Strike** and beta **Spearing Strike** are both weapon attacks, but the sources do not establish succession or compatible mechanics.
- Historical **Anger Management** and beta **Tactical Mastery** both concern Rage behavior and are passive, but they are not evidenced as aliases or replacements.

Canonical keys for exact matches should remain unchanged. Similar names, stance-related mechanics, or shared resource effects do not authorize content or saved-data transfer.

## Legacy and unresolved candidates

- **Anger Management**, **Counterattack**, **Decisive Strike**, and **Intervene** are empty RPHelper definitions absent from both current beta sources. Absence is not proof of permanent removal.
- Warrior Counterattack must not be conflated with the separate Hunter talent of the same name.
- The four existing ranged controls—Throw, Shoot Bow, Shoot Crossbow, and Shoot Gun—are beta-present but located on the General tab. Their catalogue disposition requires an explicit product decision rather than a claim of removal.

## Stance and activation considerations

Spellbook presence does not establish reliable successful-cast detection:

- Stance activations change state and may have timing or event behavior distinct from ordinary attacks. Many abilities require Battle, Berserker, or Defensive Stance.
- Heroic Strike and Cleave are queued **next-melee** attacks; successful activation and eventual weapon impact must not be conflated.
- Overpower, Revenge, Victory Rush, and similar abilities become usable only after combat conditions or triggers; their availability effects are not player activations.
- Charge and Intercept combine movement, rage changes, target restrictions, and combat-state requirements.
- Shield Bash, Shield Block, Shield Slam, and Shield Wall require a shield; several attacks have weapon or melee-range requirements.
- Shouts are direct activations, but area effects and affected targets must not be mistaken for separate player casts.
- Slam is cast-time; all other recorded class activations are instant or next-melee. None has a production spell-ID mapping authorized by this research.

## Owner decisions required

1. Approve or reject empty active definitions for the three stances, Spearing Strike, Taunt, and Victory Rush.
2. Confirm Tactical Mastery remains excluded as passive and decide the disposition of historical Anger Management without treating the two as aliases.
3. Decide whether Counterattack, Decisive Strike, and Intervene remain active legacy exceptions or move to a later archive during implementation.
4. Decide how the four existing General-tab ranged controls should be handled under the v1 General-tab exclusion while preserving player-owned data.
5. Confirm that no content or saved settings move between Decisive Strike and Spearing Strike without an explicit identity decision.
6. Defer all spell-ID mapping and detection decisions until stance changes, queued attacks, conditional availability, and successful-cast payloads are verified in client.

## Provisional implementation disposition

Subject to owner approval, a later implementation could retain the 35 confirmed active class identities, add the six missing active identities as empty definitions, exclude Tactical Mastery and all General entries from automatic promotion, and preserve all historical content and saved data. The four beta-absent definitions and the four already-catalogued General controls require explicit dispositions before production changes. No archive, migration, mapping, detection change, or authored reaction change is authorized by this research.

The row-level ranks, train levels, candidate IDs, acquisition notes, mechanics, evidence, reaction counts, scope, and provisional dispositions are in [the Warrior reconciliation CSV](warrior_beta_reconciliation.csv).
