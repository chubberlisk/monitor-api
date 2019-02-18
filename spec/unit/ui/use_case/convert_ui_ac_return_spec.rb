describe UI::UseCase::ConvertUIACReturn do
  let(:return_to_convert) do
    File.open("#{__dir__}/../../../fixtures/ac_return_ui.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  let(:core_data_return) do
    File.open("#{__dir__}/../../../fixtures/ac_return_core.json") do |f|
      JSON.parse(
        f.read,
        symbolize_names: true
      )
    end
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(return_data: return_to_convert)

    expect(converted_project).to eq(core_data_return)
  end
end
