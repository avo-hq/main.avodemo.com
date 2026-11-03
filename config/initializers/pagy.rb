# Avo 4.3.5 ships legacy ro/nn dictionaries. Pagy's loader does not read Rails'
# I18n.load_path: prefer the app's Pagy 43 dictionaries over Avo's copies.
Pagy::I18n.pathnames << Rails.root.join("config/locales/pagy")
