require "test_helper"

class Avo::Ai::ChatPolicyTest < ActiveSupport::TestCase
  test "only offers tool-capable models costing at most $1 input and $5 output per million tokens" do
    models = Avo::Ai::ChatPolicy.new(nil, Avo::Ai::Chat).available_models

    assert_equal [
      {model: "gpt-5.6-luna", provider: :openai},
      {model: "gpt-4o-mini", provider: :openai},
      {model: "claude-haiku-4-5", provider: :anthropic},
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
end
