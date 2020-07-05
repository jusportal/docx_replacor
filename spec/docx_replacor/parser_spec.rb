require "docx_replacor/parser"

RSpec.describe DocxReplacor::Parser do
  let(:text_arrays) { ["t1 %var_1% text %var_2% h1", "%var", "_", "3%%h2", "%var_4%"] }
  let(:var_values) {{ var_1: "a1", var_2: "b2", var_3: "c3", var_4: "d4" }}

  subject!(:parser) { described_class.new(var_values, text_arrays) }

  it "returns correct replacement instructions" do
    expected = [
      [0, 3..9, "a1"],
      [0, 16..22, "b2"],
      [1, 0..3, "c3"],
      [2, 0..0, ""],
      [3, 0..1, ""],
      [4, 0..6, "d4"]
    ]

    expect(parser.replacement_instructions).to match_array(expected)
  end
end
