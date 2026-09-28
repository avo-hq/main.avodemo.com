require "test_helper"

class Avo::Ai::ChatPolicyTest < ActiveSupport::TestCase
  setup do
    @previous_deepseek_api_key = ENV["DEEPSEEK_API_KEY"]
    ENV["DEEPSEEK_API_KEY"] = "test-key"
  end

  teardown do
    ENV["DEEPSEEK_API_KEY"] = @previous_deepseek_api_key
  end

  test "only offers tool-capable models costing at most $1 input and $5 output per million tokens" do
    models = Avo::Ai::ChatPolicy.new(nil, Avo::Ai::Chat).available_models

    assert_equal [
      {model: "deepseek-flash", provider: :deepseek},
      {model: "gpt-5.6-luna", provider: :openai},
      {model: "gpt-4o-mini", provider: :openai},
      {model: "gemini-2.5-flash-lite", provider: :gemini}
    ], models

    models.each do |entry|
      model = RubyLLM.models.find(entry[:model], provider: entry[:provider])
      pricing = model.pricing.text_tokens.standard

      assert_includes model.capabilities, "function_calling", "#{entry[:model]} cannot use chat tools"
      assert_operator pricing.input_per_million, :<=, 1, "#{entry[:model]} input is too expensive"
      assert_operator pricing.output_per_million, :<=, 5, "#{entry[:model]} output is too expensive"
    end
  end

  test "does not offer DeepSeek until its API key is configured" do
    ENV.delete("DEEPSEEK_API_KEY")

    models = Avo::Ai::ChatPolicy.new(nil, Avo::Ai::Chat).available_models

    refute_includes models, {model: "deepseek-flash", provider: :deepseek}
  end
end
