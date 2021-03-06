describe UI::UseCase::ConvertCoreACReturn do
  let(:return_to_convert) do
    File.open("#{__dir__}/../../../fixtures/ac_return_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:ui_data_return) do
    File.open("#{__dir__}/../../../fixtures/ac_return_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end


  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(return_data: return_to_convert)

    expect(converted_project).to eq(ui_data_return)
  end

  context 'nil data causing errors' do 
    let(:nil_data_to_convert) do
      {
      }
    end
  
    let(:returned_empty_return) do
      {
      }
    end
  
    it 'Converts nil data' do
      converted_return = described_class.new.execute(return_data: nil_data_to_convert)
      expect(converted_return).to eq(returned_empty_return)
    end
  end
end
