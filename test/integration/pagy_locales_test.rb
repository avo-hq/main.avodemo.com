require "test_helper"

class PagyLocalesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # Match production: add-on UI strings fall back to English. Pagy's own
    # dictionary loader is independent of these Rails I18n fallbacks.
    @i18n_backend = I18n.backend
    @i18n_fallbacks = I18n.fallbacks
    I18n.backend = I18n.backend.dup.extend(I18n::Backend::Fallbacks)
    I18n.fallbacks = I18n::Locale::Fallbacks.new(:en)

    @admin = User.create!(
      first_name: "Pagination",
      last_name: "Admin",
      email: "pagination-#{SecureRandom.hex(4)}@example.com",
      password: "secreto123",
      roles: {"admin" => true}
    )
    sign_in @admin

    3.times do |index|
      Avo::Ai::Chat.create!(name: "Pagination chat #{index}", user: @admin)
      Avo::Ai::Model.create!(name: "Pagination model #{index}", model_id: "pagination-#{index}", provider: "openai")
    end
  end

  teardown do
    I18n.backend = @i18n_backend
    I18n.fallbacks = @i18n_fallbacks
  end

  test "AI chat and model indexes paginate in Romanian, Nynorsk and English" do
    {ro: ["Pagini", "Înapoi", "Înainte"], nn: ["Sider", "Førre", "Neste"], en: ["Pages", "Previous", "Next"]}.each do |locale, labels|
      %w[chats models].each do |resource|
        get "https://main.avodemo.com/avo/resources/avo_ai/#{resource}",
          params: {force_locale: locale, per_page: 1, page: 2}

        assert_response :success
        assert_select ".pagination__nav nav[aria-label=?]", labels[0] do
          assert_select "a[aria-label=?]", labels[1]
          assert_select "a[aria-label=?]", labels[2]
          assert_select "a[aria-current=page]", text: "2"
        end
        assert_no_match(/translation missing/i, response.body)
      end
    end
  end
end
