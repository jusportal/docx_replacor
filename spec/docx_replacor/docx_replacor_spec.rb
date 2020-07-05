require 'docx_replacor'

RSpec.describe DocxReplacor::Document do
  let(:file_url) { "spec/fixtures/test.docx" }
  let(:var_values) {{ awesome_name: "Jus Portal", date_of_birth: "01/02/2000" }}

  subject!(:replacor) { described_class.new(file_url) }

  it "creates a file buffer" do
    expect(replacor.file_buffer.size).to_not eq 0
  end

  it "creates text nodes array" do
    expect(replacor.text_nodes.any?).to eq true
  end

  it "returns matched variables" do
    expect(replacor.match([:awesome_name, :no_matching])).to match_array([:awesome_name])
  end

  it "substitute variable values" do
    expected = "awesome_nameJus Portaldate_of_birth01/02/2000awesome_nameJus Portalnot_a_variable_name01/02/2000Jus Portal(01/02/2000) wrote a paragraph on a test file."
    expect(replacor.substitute(var_values).document_texts).to eq expected
  end
end
