# Avo 3 → Avo 4 Upgrade

Upgrade of this app from Avo `3.31.0` to Avo `4.0.0.beta.37` (suite gems at their
matching betas). Guide: https://docs.avohq.io/4.0/avo-3-avo-4-upgrade.html

**Status: ✅ Complete.** All 16 resources (index/show/edit/new), dashboards, global
search, custom tool pages, nested forms, map view, and grid views render `200`
when signed in. Verified via an authenticated integration sweep of every resource
and every code path touched below.

## Chapters

- [x] **1. Get Started** — Bumped the Avo gems and ran `bundle install`. Installed:
  `avo 4.0.0.beta.37`, `avo-advanced 4.0.0.beta.12`, `avo-pro beta.19`,
  `avo-dashboards beta.15`, `avo-dynamic_filters beta.13`, `avo-menu beta.12`,
  `avo-licensing beta.8`, `avo-nested 4.0.0.beta.8` (**newly added** — see Ch. 9),
  `avo-rhino_field 4.0.0` (from rubygems; the packager copy 403s), `view_component 4.0.0`.
  `avo-money_field` kept at `0.0.5` (no v4 release; only depends on `money-rails`, works with Avo 4).
  ⚠️ Pinned to **exact** versions on purpose — see "Findings → Gem pinning".
- [x] **2. Icons** — Heroicons → Tabler. Migrated every explicit `heroicons/...`
  reference to its `tabler/outline/...` equivalent (`finger-print`→`fingerprint`,
  `academic-cap`→`school`, `eye-slash`→`eye-off`, `arrow-trending-up/down`→`trending-up/down`,
  `arrow-top-right-on-square`→`external-link`, `globe`→`world`, `hand-raised`→`hand-stop`,
  `information-circle`→`info-circle`, `trash`). Files: `fish.rb`, `base_resource.rb`,
  `post.rb`, `project.rb`, `product.rb`, `avo.rb`, `custom_page/_fish_information/_user_tool` views.
  (Heroicons are still bundled in `avo-icons`, so bare/local-asset icons like `user-circle`
  and `demo-adjustments.svg` still resolve and were left as-is.)
- [x] **3. Avatars and Initials** — Additive feature; adopted via the renamed
  `self.avatar` (see Ch. 12). No extra work needed.
- [x] **4. Search** — Removed the now-unused `help:` key from `Post`'s `self.search`.
  `User`'s `self.search` already used the Avo 4 `item:` hash format (`title/description/image_url`).
  No `result_path:`, `disabled_features`, or search `help:` lambdas remained elsewhere.
  Verified resource search + global search (`/avo/search`) return 200.
- [x] **5. Actions** — `self.no_confirmation` → `self.confirmation` (inverted).
  `ExportCsv`: `no_confirmation = false` → `confirmation = true`. The `Post`
  discreet-info toggle link passed `no_confirmation: true`; switched it to
  `confirmation: false` and gave `TogglePublished` the dynamic
  `self.confirmation = -> { arguments.key?(:confirmation) ? arguments[:confirmation] : true }`.
- [x] **6. Layout** — `main_panel` removed (it raises in v4). `User`, `Team`, `Movie`
  all had a sidebar → converted `main_panel do` to `panel do` + wrapped non-sidebar
  fields in `card do` (guide Scenario 2). Views: `Avo::PanelComponent` →
  `Avo::UI::PanelComponent`, `with_tools` → `with_controls`,
  `with_bare_content` → `with_body`, `with_footer_tools` → `with_footer`,
  `name:` prop → `title:`, dropped the removed `display_breadcrumbs:` prop.
  Keyword args: `tab "X"` → `tab title: "X"` (`User`, `Fish` ×8).
- [x] **7. Branding → Appearance** — `config.branding` was commented out; rewrote the
  commented block as `config.appearance` with the new `accent`/`accent_colors` shape
  (the flat `colors:` hash is gone). Verified `Avo::Configuration::Appearance` accepts
  `logo/logomark/accent/accent_colors`.
- [x] **8. Components** — No `Avo::Index::ResourceMapComponent` /
  `ResourceTableComponent` references existed in any `self.components`. Nothing to change.
- [x] **9. Nested Association Forms** — Added `gem "avo-nested"` (no longer bundled in
  `avo-advanced`). Used by `Fish` (`_nested_fish_reviews`) and `Course` (`links … nested: true`).
- [x] **10. Pagination** — No `self.pagination` with `size:` anywhere. Nothing to change.
- [x] **11. Breadcrumbs** — `Avo::ToolsController#custom_page`:
  `add_breadcrumb "Your custom page"` → `add_breadcrumb title: "Your custom page"`.
- [x] **12. Renamed Configurations** — `self.profile_photo` → `self.avatar` (`User`, `Event`);
  `self.cover_photo` → `self.cover` (`Event`). Left the underlying model
  attachments/fields (`field :cover_photo`, `:profile_photo`, `attachments: [:cover_photo]`) untouched.
- [x] **13. Grid Item Badge DSL** — No grid cards used the flat `badge_label/badge_color/badge_title`
  keys. Nothing to change.
- [x] **14. Discreet Information** — Per the v4 `Avo::DiscreetInformation` source, hash keys
  are now `title/icon/url/target/data/text/key/value/as`. Renamed `tooltip:`→`title:`,
  `label:`→`text:`, `url_target:`→`target:` (`Post`, `Product`, `Project`); replaced the
  removed `:id_badge` symbol with `:id` (`Project`).
- [x] **15. Width (cluster/row removed)** — `User` used `row do … end` around 3 fields;
  removed the `row` wrapper and gave each field `width: 33`.
- [x] **16. Map View Positioning** — `City`: `table: { visible: true, layout: :bottom }`
  → `table: { visible: true }, map: { position: :top }` (layout value inverted, per the
  new `MapComponent#map_position` reading `map_options.dig(:map, :position)`).
- [x] **17. New Features** — None required. No `config.full_width_index_view` /
  `cluster` / removed APIs left to migrate; optional adoptions (`label_help`,
  `container_width`, resource `self.icon`, etc.) left for later.
- [x] **18. Boot & verify** — `Rails.application.eager_load!` clean; authenticated
  integration sweep of all resources + forms + tools + search returns 200/302.

## Findings (issues beyond the guide's chapters)

These broke the app on boot/render but are **not** covered by the official guide —
they're app-specific customizations that used removed Avo internals:

1. **`app/views/avo/partials/_footer.html.erb`** (custom override) called
   `Avo.license.id`. `Avo.license` was removed in v4 (licensing moved to the
   `avo-licensing` gem). Since the footer rendered on every page, *every* Avo page
   500'd. Removed the `title="<%= Avo.license.id %>"` tooltip; kept version/account info.
2. **`field_container` helper removed in v4.** Replace it with `ui.description_list` to keep
   fields full width inside a card. Affected: `_city_editor`, `_fish_information`, `_fish_review`.
   Also: when a partial already renders its own card, its parent panel must use `with_body`
   (not `with_card`) to avoid a card nested in a card.
3. **Gem pinning** — A `>=` constraint is unsafe for Avo 4 betas: the
   `4.0.0.pre.dev.*` dev builds sort **higher** than `4.0.0.beta.*` in RubyGems
   ordering (`"pre" > "beta"`), so `>=` resolved to a broken non-booting `pre.dev`
   build. The Avo gems are pinned to exact versions in the `Gemfile`; bump them
   explicitly when moving between betas.

## Known benign warning

- `Team` resource: `field :preview, as: :preview` logs
  `Failed to find component for the Avo::Fields::PreviewField field on the show view`.
  The page still renders 200. Not a documented v3→v4 break; left as-is. If undesired,
  scope the field with `only_on: :index` (it's only meaningful for index hover-preview).
