# RPHelper Forever documentation

RPHelper Forever is currently a **v0.9 prerelease** intended for live-client
verification. The repository implementation and deterministic test suites cover
the documented schema, runtime policy, editor, Guide/About, and diagnostic mode,
but this is not the V1.0 stable release.

## Authoritative policy map

| Policy | Authoritative source |
| --- | --- |
| Product scope, trigger families, output routing, anti-spam, and release status | [Product specification](product_spec.md) |
| Content layers, templates, keywords, candidate eligibility, and reactive-trigger semantics | [Content engine specification](content_engine.md) |
| Per-character data ownership and runtime pool | [Data and persistence architecture](data_architecture.md) |
| Schema v2, sparse overrides, immutable built-ins, Custom records, and permanent IDs | [SavedVariables architecture](savedvariables_architecture.md) |
| Character Library/editor, Priority, weights, preview, Guide, and About | [UI/UX specification](ui_ux_spec.md) |
| Ability-catalogue eligibility and reconciliation method | [Forever ability reconciliation](forever_ability_reconciliation.md) |

The [runtime API assumptions](runtime_api_assumptions.md) and [user-content
runtime reference](user_content_runtime.md) explain the implemented technical
boundaries. The [runtime integration audit](audits/runtime_integration_audit.md)
is the dated implementation/verification matrix, not a replacement for approved
product policy.

## Current implementation boundary

The runtime detects five generic triggers: combat entry, combat exit, player
Dodge, Parry, and direct Block. Offensive `youcrit`, death, resurrection, level,
killing-blow, monster, pet, and NPC pools may be browsable or authored without a
production detector. Ability browsing likewise does not imply runtime support:
only Paladin Flash of Light spell ID `19750` and Seal of Righteousness spell ID
`20288` are runtime-mapped. Unknown IDs, other ranks, and all other browsable
abilities remain unmapped.

Schema v2 settings and content are character-specific. Built-in catalogue data
is immutable; disabling or weighting it stores a sparse override, and Modify
creates an independent Custom copy. Chance, the shared cooldown, optional quota,
weights, and Priority follow the product-specification pipeline. Priority bypasses
only the cooldown. Druid shapeshift forms suppress Say candidates, and routing is
world-local, dungeon `/say` or per-character local, and fully suppressed in raids.

The Character Library/editor and the bounded in-game Guide and About pages are
implemented. Opt-in diagnostics are local, session-only, bounded, and disabled
by default.

## Known client-verification limitations

Mocked suites cannot prove WoW Forever event registration, secret-value
readability, payload attribution and ordering, activity classification,
automatic chat/emote permission, emote-token availability, Druid form IDs, or
SavedVariables persistence across a real logout, reload, and addon update. See
[runtime API assumptions](runtime_api_assumptions.md), the [combat audit](audits/combat_trigger_api_audit.md),
and the [spellcasting audit](spell_casting_api_audit.md). No workaround for
client restrictions is intended.

## Audience and release documentation

- Players should start with the root [README](../README.md) and use the completed
  in-game Guide. Repository specifications and audits are not a player manual.
- Developers and maintainers should use the authoritative policy map above and
  the repository [agent/workflow instructions](../AGENTS.md).
- Auditors and future contributors should use the dated reports and companion
  inventories under [audits](audits/).

CurseForge publishing copy, GitHub release notes, concise installation/update
instructions, a packaging/release checklist, verified client/interface support,
and release screenshots are not yet repository documents. They belong to a
separate distribution milestone; they should summarize rather than duplicate
the in-game Guide.

## File inventory and disposition

Classification describes each Markdown and CSV file tracked by the repository.
Historical files retain their original findings; later status notes are clearly
dated. No file is proposed for deletion.

### Repository and current documentation

| File | Classification | Disposition |
| --- | --- | --- |
| [Root README](../README.md) | Active reference | Keep as the short player/project entry point. |
| [AGENTS.md](../AGENTS.md) | Active reference | Keep at root as the maintainer workflow contract. |
| [Bug report template](../.github/ISSUE_TEMPLATE/bug_report.md) | Active reference | Keep under `.github`; contributor workflow. |
| [Content suggestion template](../.github/ISSUE_TEMPLATE/content_suggestion.md) | Active reference | Keep under `.github`; contributor workflow. |
| [Feature request template](../.github/ISSUE_TEMPLATE/feature_request.md) | Active reference | Keep under `.github`; contributor workflow. |
| [docs/README.md](README.md) | Active reference | Keep as the documentation index and consolidated inventory. |
| [product_spec.md](product_spec.md) | Authoritative specification | Keep directly under `docs/`; primary product policy. |
| [content_engine.md](content_engine.md) | Authoritative specification | Keep directly under `docs/`; content and trigger semantics. |
| [data_architecture.md](data_architecture.md) | Authoritative specification | Keep directly under `docs/`; ownership and runtime-pool policy. |
| [savedvariables_architecture.md](savedvariables_architecture.md) | Authoritative specification | Keep directly under `docs/`; schema-v2 policy. |
| [ui_ux_spec.md](ui_ux_spec.md) | Authoritative specification | Keep directly under `docs/`; approved UI behavior. |
| [forever_ability_reconciliation.md](forever_ability_reconciliation.md) | Authoritative specification | Keep directly under `docs/`; ability-review method, not a runtime allowlist. |
| [runtime_api_assumptions.md](runtime_api_assumptions.md) | Active reference | Keep directly under `docs/`; current adapter and live-test boundaries. |
| [user_content_runtime.md](user_content_runtime.md) | Active reference | Keep directly under `docs/`; implemented editor/runtime API details. |
| [spell_casting_api_audit.md](spell_casting_api_audit.md) | Historical audit | Keep at its existing path because production source cites it; index it with other audits. |

### Historical reports

| File | Classification | Disposition |
| --- | --- | --- |
| [ability_catalogue_reconciliation.md](audits/ability_catalogue_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [ability_spell_mapping_audit.md](audits/ability_spell_mapping_audit.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [combat_trigger_api_audit.md](audits/combat_trigger_api_audit.md) | Historical audit | Retain under `docs/audits/`; current live checks remain useful. |
| [druid_beta_reconciliation.md](audits/druid_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [forever_ability_coverage_audit.md](audits/forever_ability_coverage_audit.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [hunter_beta_reconciliation.md](audits/hunter_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [hunter_pet_reconciliation.md](audits/hunter_pet_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [mage_beta_reconciliation.md](audits/mage_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [paladin_beta_reconciliation.md](audits/paladin_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [pet_command_feasibility_audit.md](audits/pet_command_feasibility_audit.md) | Historical audit | Retain under `docs/audits/` with its inventory. |
| [pet_runtime_feasibility_audit.md](audits/pet_runtime_feasibility_audit.md) | Historical audit | Retain under `docs/audits/` with its inventory. |
| [placeholder_compatibility_audit.md](audits/placeholder_compatibility_audit.md) | Historical audit | Retain under `docs/audits/` with its inventory. |
| [priest_beta_reconciliation.md](audits/priest_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [rogue_beta_reconciliation.md](audits/rogue_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [runtime_integration_audit.md](audits/runtime_integration_audit.md) | Historical audit | Retain under `docs/audits/` with its inventory; use as the latest dated status matrix. |
| [runtime_wiring_audit.md](audits/runtime_wiring_audit.md) | Historical audit | Retain under `docs/audits/`; preserve its original baseline plus dated status note. |
| [shaman_beta_reconciliation.md](audits/shaman_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [ui_feasibility_audit.md](audits/ui_feasibility_audit.md) | Historical audit | Retain under `docs/audits/`; implementation follow-up remains useful. |
| [warlock_beta_reconciliation.md](audits/warlock_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [warlock_demon_reconciliation.md](audits/warlock_demon_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [warrior_beta_reconciliation.md](audits/warrior_beta_reconciliation.md) | Historical audit | Retain under `docs/audits/` with its CSV. |
| [prelaunch_plan.md](audits/prelaunch_plan.md) | Superseded or redundant | Retain as a historical planning snapshot with a dated status note; do not delete. |

### Machine-readable inventories

| File | Classification | Disposition |
| --- | --- | --- |
| [ability_catalogue_reconciliation_inventory.csv](audits/ability_catalogue_reconciliation_inventory.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [ability_spell_mapping_inventory.csv](audits/ability_spell_mapping_inventory.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [druid_beta_reconciliation.csv](audits/druid_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [forever_ability_coverage_inventory.csv](audits/forever_ability_coverage_inventory.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [hunter_beta_reconciliation.csv](audits/hunter_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [hunter_pet_reconciliation.csv](audits/hunter_pet_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [mage_beta_reconciliation.csv](audits/mage_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [paladin_beta_reconciliation.csv](audits/paladin_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [pet_command_ability_inventory.csv](audits/pet_command_ability_inventory.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [pet_runtime_feasibility_inventory.csv](audits/pet_runtime_feasibility_inventory.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [placeholder_compatibility_inventory.csv](audits/placeholder_compatibility_inventory.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [priest_beta_reconciliation.csv](audits/priest_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [rogue_beta_reconciliation.csv](audits/rogue_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [runtime_ability_integration_inventory.csv](audits/runtime_ability_integration_inventory.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [shaman_beta_reconciliation.csv](audits/shaman_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [warlock_beta_reconciliation.csv](audits/warlock_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [warlock_demon_reconciliation.csv](audits/warlock_demon_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |
| [warrior_beta_reconciliation.csv](audits/warrior_beta_reconciliation.csv) | Machine-readable inventory | Retain beside its report unchanged. |

No current authoritative specification is classified as superseded. No direct
approved-behavior/implementation contradiction was found during consolidation.
The remaining gaps are explicitly scoped unimplemented trigger families,
limited runtime ability mappings, missing distribution documentation/metadata,
and live-client verification—not silent changes to approved behavior.
